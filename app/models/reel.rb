class Reel < ActiveRecord::Base
  include Orderable

  has_many :clips
end
