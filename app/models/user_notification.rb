class UserNotification < ApplicationRecord
  acts_as_paranoid

  belongs_to :notification
  belongs_to :user

  scope :not_seen, ->{where seen: false}
  scope :select_notifications, ->{includes(notification: :trackable).order created_at: :desc}
end
