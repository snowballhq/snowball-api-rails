class Follow < ActiveRecord::Base
  include Orderable

  validates :follower, presence: true
  validates :following, presence: true

  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  after_create :send_push_notification

  private

  def send_push_notification
    following.send_push_notification("#{follower.username} is now following you.")
  end
end
