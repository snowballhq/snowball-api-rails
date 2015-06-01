class Follow < ActiveRecord::Base
  include Orderable

  validates :follower, presence: true
  validates :following, presence: true

  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  after_create :send_push_notification

  private

  def send_push_notification
    headers = {
      'X-Parse-Application-Id' => ENV['PARSE_APPLICATION_ID'],
      'X-Parse-REST-API-Key' => ENV['PARSE_API_KEY'],
      'Content-Type' => 'application/json'
    }
    message = "#{follower.username} is now following you."
    body = {
      where: {
        user_id: following.id
      },
      data: {
        alert: message
      }
    }
    HTTParty.post('https://api.parse.com/1/push', body: body.to_json, headers: headers, verify: false)
  end
end
