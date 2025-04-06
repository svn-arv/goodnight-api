class BaseController < ApplicationController
  before_action :set_current_user
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # Use callbacks to share common setup or constraints between actions.
  def set_current_user
    @current_user = User.find(params[:user_id])
  end

  def not_found(exception)
    render json: { error: exception }, status: :not_found
  end
end
