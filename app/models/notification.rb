class Notification < ActiveRecord::Base
  include Orderable

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :user, presence: true
  validates :notifiable, presence: true

  def action
    notifiable_type.downcase
  end

  def clip
    notifiable.likeable if notifiable_type == 'Like'
  end

  def message
    "#{notifiable.user.username} liked your clip." if notifiable_type == 'Like'
  end
end
