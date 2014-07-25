class Notification < ActiveRecord::Base
  include Orderable

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :user, presence: true
  validates :notifiable, presence: true

  after_create :send_push_notification

  def send_push_notification
    return if Rails.env.test?
    # TODO: schedule this for after the clip is saved with no zencoder ID
    # TODO: send push actions (inside notification object) if it is a reel: :actions=>{:open=>{:type=>"deep_link", :content=>"snowball://reel/12345"}}}
    push = {
      audience: { alias: [user.id] },
      notification: { alert: message },
      device_types: "all"
    }
    Urbanairship.push(push.merge(version: 3))
  end

  def message
    notifiable.push_notification_message
  end
end
