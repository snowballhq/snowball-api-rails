class Follow < ActiveRecord::Base
  include Notifiable

  belongs_to :user
  belongs_to :followable, polymorphic: true

  validates :user, presence: true
  validates :followable, presence: true
end
