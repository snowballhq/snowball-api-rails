class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :participants, through: :participations, source: :user

  def recent_participants_names
    return name if name
    participants.last(5).map(&:name).map do |n|
      n.split[0...-1].join ' '
    end.join(', ')
  end
end
