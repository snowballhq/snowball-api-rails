class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :participants, through: :participations, source: :user

  def recent_participants_names
    participants.where('name IS NOT NULL').last(5).map(&:name).map do |n|
      n.split[0...-1].join ' '
    end.join(', ')
  end
end
