class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips

  validates :name, presence: true
end
