class Flag < ActiveRecord::Base
  include Orderable

  validates :clip, presence: true

  belongs_to :clip
end
