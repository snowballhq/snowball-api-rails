class Participation < ActiveRecord::Base
  validates :reel, presence: true
  validates :user, presence: true

  belongs_to :reel
  belongs_to :user
end
