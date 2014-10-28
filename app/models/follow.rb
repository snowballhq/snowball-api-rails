class Follow < ActiveRecord::Base
  include Orderable

  validates :follower, presence: true
  validates :following, presence: true

  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'
end
