class Follow < ActiveRecord::Base
  include Notifiable

  belongs_to :user
  belongs_to :followable, polymorphic: true

  validates :user, presence: true
  validates :followable, presence: true

  def push_notification_message
    "#{user.username} has followed you."
  end
end
