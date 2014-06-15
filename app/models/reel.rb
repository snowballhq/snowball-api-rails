class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :participants, through: :participations, source: :user
end
