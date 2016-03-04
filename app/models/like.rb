class Like < ActiveRecord::Base
  include Orderable

  validates :clip, presence: true
  validates :user, presence: true

  belongs_to :clip
  belongs_to :user

  after_create :send_push_notification

  private

  def send_push_notification
    clip.user.send_push_notification("#{user.username} liked your clip. 👍")
  end
end
