class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :participants, through: :participations, source: :user

  def recent_participants
    # TODO: make this display last 5 participants
    participants.last 5
  end

  def friendly_name
    return name if name
    recent_participants.map(&:name).collect do |n|
      n.split[0...-1].join ' '
    end.join(', ')
  end
end
