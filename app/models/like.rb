class Like < ActiveRecord::Base
  include Notifiable

  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: true

  validates :user, presence: true
  validates :likeable, presence: true
end
