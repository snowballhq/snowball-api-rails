class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :participants, through: :participations, source: :user

  def recent_participants
    # TODO: make this display last 5 participants
    participants.last 5
  end
end
