class DevicesController < ApplicationController
  before_action :authenticate_user!

  def create
    device = @current_user.devices.find_by(token: device_params[:token])
    if device
      device.development = false
      device.update!(device_params)
    else
      device = @current_user.devices.create!(device_params)
    end

    # TODO: Do this in the background...
    # Also, maybe this should be called from the model when created?
    arn = ENV['AWS_SNS_ARN_IOS']
    arn = ENV['AWS_SNS_ARN_IOS_DEVELOPMENT'] if device.development?
    AWS::SNS.new.client.create_platform_endpoint(
      platform_application_arn: arn,
      token: device.token,
      custom_user_data: device.user_id
    )
    head :accepted
  end

  private

  def device_params
    params.permit(
      :platform,
      :token,
      :development
    )
  end
end
