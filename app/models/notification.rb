class Notification < ActiveRecord::Base
  include Orderable

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :user, presence: true
  validates :notifiable, presence: true

  after_create :send_push_notification

  def send_push_notification
    return if Rails.env.test?
    notification = {
      aliases: [user.id],
      aps: { alert: message }
    }
    Urbanairship.push(notification)
  end

  def action
    notifiable_type.downcase
  end

  def message
    return "#{notifiable.user.username} has followed you." if notifiable_type == 'Follow'
    return "#{notifiable.user.username} sent you a clip." if notifiable_type == 'Clip'
  end
end
