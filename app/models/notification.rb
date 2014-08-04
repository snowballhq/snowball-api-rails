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
    push = {
      audience: { alias: [user.id] },
      notification: { alert: message },
      device_types: 'all'
    }
    push[:notification][:actions] = { app_defined: { '^d' => "snowball://reel/#{notifiable.reel.id}" } } if notifiable.instance_of?(Clip)
    Urbanairship.push(push.merge(version: 3))
  end

  def message
    notifiable.push_notification_message
  end
end
