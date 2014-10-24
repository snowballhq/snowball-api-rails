class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
  has_many :participations
  has_many :users, through: :participations

  def users_title
    users.last(5).map(&:name).map do |n|
      [n.split.first].join(' ') unless n.nil?
    end.join(', ')
  end

  def next_clip(user)
    participation = Participation.where(user: user, reel: self).first
    return nil unless participation
    clip = participation.last_watched_clip
    return clips.last(10).first unless clip
    clips.where('created_at >= ? AND id != ?', clip.created_at, clip.id).order('created_at DESC').first
  end
end
