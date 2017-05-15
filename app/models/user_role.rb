class UserRole < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :role
  validates :user, presence: true
  validates :role, presence: true
end
