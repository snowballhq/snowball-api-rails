class Device < ActiveRecord::Base
  include Orderable

  validates :user, presence: true
  validates :development, inclusion: { in: [true, false] }
  validates :type, inclusion: { in: [0] }
  validates :token, presence: true

  belongs_to :user
end
