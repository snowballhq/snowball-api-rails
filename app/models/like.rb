class Like < ActiveRecord::Base
  include Orderable

  validates :clip, presence: true
  validates :user, presence: true

  belongs_to :clip
  belongs_to :user

  after_create :send_push_notification

  private

  def send_push_notification
    headers = {
      'X-Parse-Application-Id' => ENV['PARSE_APPLICATION_ID'],
      'X-Parse-REST-API-Key' => ENV['PARSE_API_KEY'],
      'Content-Type' => 'application/json'
    }
    message = "#{user.username} liked your clip."
    body = {
      where: {
        user_id: clip.user.id
      },
      data: {
        alert: message
      }
    }
    HTTParty.post('https://api.parse.com/1/push', body: body.to_json, headers: headers, verify: false)
  end
end
