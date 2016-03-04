class DevicesController < ApplicationController
  before_action :authenticate_user!

  def create
    device = @current_user.devices.find_or_create_by!(token: device_params[:token]) do |temp_device|
      temp_device.development = false
      temp_device.assign_attributes(device_params)
    end
    # TODO: Do this in the background...
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
