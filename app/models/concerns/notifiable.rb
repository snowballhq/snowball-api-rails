module Notifiable
  extend ActiveSupport::Concern

  included do
    after_create :create_notification
    after_destroy :destroy_notification
  end

  def create_notification
    return if user == user_from_class_name # don't create a notification for user on actions user takes
    if self.class.name == 'Clip'
      self.reel.participants.each do |u|
        u.notifications.create(notifiable: self)
      end
    else
      user_from_class_name.notifications.create(notifiable: self)
    end
  end

  def destroy_notification
    if self.class.name == 'Clip'
      self.reel.participants.each do |u|
        u.notifications.where(notifiable: self).destroy_all
      end
    else
      user_from_class_name.notifications.where(notifiable: self).destroy_all
    end
  end

  def user_from_class_name
    return followable if self.class.name == 'Follow'
  end
end
