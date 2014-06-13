class Clip < ActiveRecord::Base
  include Orderable
  include VideoEncoder

  belongs_to :reel, touch: true
  belongs_to :user

  accepts_nested_attributes_for :reel

  validates :reel, presence: true
  validates :user, presence: true

  has_attached_file :video
  validates_attachment_presence :video
  validates_attachment_file_name :video, matches: [/mp4\Z/]

  after_create :encode_video
end
