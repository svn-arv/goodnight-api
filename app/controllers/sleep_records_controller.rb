class SleepRecordsController < BaseController
  before_action :set_sleep_record, only: %i[clock_out]

  # POST /clock_in
  def clock_in
    action_result = Actions::SleepRecord::ClockIn.call(user: @current_user, time: sleep_record_params[:at])

    if action_result.success?
      render json: action_result.result
    else
      render json: action_result.errors, status: :unprocessable_entity
    end
  end

  # POST /clock_out
  def clock_out
    action_result = Actions::SleepRecord::ClockOut.call(sleep_record: @sleep_record, time: sleep_record_params[:at])

    if action_result.success?
      render json: action_result.result
    else
      render json: action_result.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sleep_record
    @sleep_record = SleepRecord.find(params[:sleep_record_id])
  end

  # Only allow a list of trusted parameters through.
  def sleep_record_params
    params.permit(:at)
  end
end
