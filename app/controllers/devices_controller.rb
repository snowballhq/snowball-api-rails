class DevicesController < ApplicationController
  before_action :authenticate_user!

  def create
    if !device_params[:type]
      render json: { message: 'Type can\'t be blank' }, status: :bad_request
    elsif !device_params[:token]
      render json: { message: 'Token can\'t be blank' }, status: :bad_request
    else
      # TODO: Do this in the background...
      arn = ENV['AWS_SNS_ARN_IOS']
      arn = ENV['AWS_SNS_ARN_IOS_DEVELOPMENT'] if device_params[:development]
      AWS::SNS.new.client.create_platform_endpoint(
        platform_application_arn: arn,
        token: device_params[:token],
        custom_user_data: @current_user.id
      )
      head :accepted
    end
  end

  private

  def device_params
    params.permit(
      :type,
      :token,
      :development
    )
  end
end
