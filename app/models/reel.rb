class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :participants, through: :participations, source: :user

  def recent_participants_names
    participants.last(5).map(&:name).map do |n|
      [n.split.first].join ' '
    end.join(', ')
  end

  def friendly_name
    return name if name
    recent_participants_names
  end
end
