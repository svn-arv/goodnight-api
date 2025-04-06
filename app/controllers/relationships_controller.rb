class RelationshipsController < BaseController
  before_action :set_following_user, only: %i[follow unfollow]

  # POST /follow
  def follow
    action_result = Actions::Relationship::Follow.call(user: @current_user, following: @following_user)

    if action_result.success?
      render json: action_result.result
    else
      render json: action_result.errors, status: :unprocessable_entity
    end
  end

  # POST /unfollow
  def unfollow
    action_result = Actions::Relationship::Unfollow.call(user: @current_user, following: @following_user)

    if action_result.success?
      render json: action_result.result
    else
      render json: action_result.errors, status: :unprocessable_entity
    end
  end

  # GET /following_sleep_records
  def following_sleep_records
    relationship_result = Actions::Relationship::Read.call(filters: { user: @current_user })
    following_ids = relationship_result.result.pluck(:following_id)

    action_result = Actions::SleepRecord::Read.call(
      filters: { user_id: following_ids },
      scopes: [[:on_or_after, :start_at, 1.week.ago]],
      order: { duration_in_seconds: :desc }
    )

    render json: action_result.result
  end

  private

  def set_following_user
    @following_user = User.find(follow_params[:following_id])
  end

  def follow_params
    params.permit(:following_id)
  end
end
