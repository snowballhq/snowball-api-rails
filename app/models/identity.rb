class Identity < ActiveRecord::Base
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :user, presence: true

  def self.find_by_auth_hash(auth_hash)
    find_by provider: auth_hash[:provider], uid: auth_hash[:uid]
  end

  def self.create_with_auth_hash(auth_hash)
    create! provider: auth_hash[:provider], uid: auth_hash[:uid]
  end
end
