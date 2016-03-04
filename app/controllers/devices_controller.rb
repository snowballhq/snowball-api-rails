class DevicesController < ApplicationController
  before_action :authenticate_user!

  def create
    # TODO: Do this in the background...
    # Also, maybe this should be called from the model when created?
    token = device_params[:token]
    unless token
      render json: { message: 'Token can\'t be blank' }, status: :bad_request
      return
    end
    arn = ENV['AWS_SNS_ARN_IOS']
    arn = ENV['AWS_SNS_ARN_IOS_DEVELOPMENT'] if device_params[:development] == true
    response = AWS::SNS.new.client.create_platform_endpoint(
      platform_application_arn: arn,
      token: token
    )
    if response.data[:endpoint_arn]
      @current_user.devices.find_or_create_by!(arn: response[:endpoint_arn])
    end
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
