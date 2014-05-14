class Reel < ActiveRecord::Base
  has_many :clips

  validates :name, presence: true
end
