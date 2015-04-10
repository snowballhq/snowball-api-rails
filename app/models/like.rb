class Like < ActiveRecord::Base
  include Orderable

  validates :clip, presence: true
  validates :user, presence: true

  belongs_to :clip
  belongs_to :user
end
