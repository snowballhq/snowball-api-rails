class Reel < ActiveRecord::Base
  has_many :clips
  has_many :participations
  has_many :users, through: :participations
end
