class Device < ActiveRecord::Base
  include Orderable

  validates :user, presence: true
  validates :development, inclusion: { in: [true, false] }
  validates :platform, inclusion: { in: [0] }
  validates :token, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :user

  before_save do
    clean_token
  end

  def clean_token
    self.token = token.delete(' ')
  end
end
