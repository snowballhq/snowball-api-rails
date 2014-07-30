class Follow < ActiveRecord::Base
  include Notifiable

  belongs_to :user
  belongs_to :followable, polymorphic: true

  validates :user, presence: true
  validates :followable, presence: true

  after_create :create_notification

  def push_notification_message
    "#{user.username} has followed you."
  end
end
