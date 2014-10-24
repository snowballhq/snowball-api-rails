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
end
