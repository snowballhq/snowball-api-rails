class Device < ActiveRecord::Base
  include Orderable

  validates :user, presence: true
  validates :arn, presence: true

  belongs_to :user
end
