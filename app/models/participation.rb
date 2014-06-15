class Participation < ActiveRecord::Base
  include Orderable

  belongs_to :user
  belongs_to :reel

  validates :user, presence: true
  validates :reel, presence: true
end
