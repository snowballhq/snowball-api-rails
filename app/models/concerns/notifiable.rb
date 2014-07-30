module Notifiable
  extend ActiveSupport::Concern

  included do
    after_destroy :destroy_notification
  end

  def create_notification
    if self.class.name == 'Clip'
      reel.participants.each do |u|
        u.notifications.create(notifiable: self) unless u == user
      end
    else
      user_from_class_name.notifications.create(notifiable: self) unless user == user_from_class_name
    end
  end

  def destroy_notification
    if self.class.name == 'Clip'
      reel.participants.each do |u|
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
