module Notifiable
  extend ActiveSupport::Concern

  included do
    after_create :create_notification
    after_destroy :destroy_notification
  end

  def create_notification
    user_from_class_name.notifications.create(notifiable: self)# unless user == user_from_class_name
  end

  def destroy_notification
    user_from_class_name.notifications.where(notifiable: self).destroy_all
  end

  def user_from_class_name
    likeable.user if self.class.name == 'Like'
  end
end
