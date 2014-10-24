class Reel < ActiveRecord::Base
  has_many :clips
  has_many :participations
  has_many :users, through: :participations

  def users_title
    users.last(5).map(&:name).map do |n|
      [n.split.first].join ' '
    end.join(', ')
  end
end
