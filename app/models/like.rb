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
      'Authorization' => 'key=' + ENV['GCM_API_KEY'],
      'Content-Type' => 'application/json'
    }
    message = "#{user.username} liked your clip."
    to = 'mWcWGCK9jeA:APA91bHrTDhhYRinvH1U0ArtIDSJmqjweUCOSW5t0kTrm7RHWAYY0QpYMM8U8e2gURjVK__SzJk-B1Iw3kttbgA0V4AflUQOtVk9XpimX5_3V6AkGElZ_Ky2hMreNmXN21dYAf6UxzDz'
    params = {
      to: to,
      notification: {
        body: message
      }
    }
    HTTParty.post('https://gcm-http.googleapis.com/gcm/send', body: params.to_json, headers: headers, verify: false)
  end
end
