class UserType < ApplicationRecord
  acts_as_paranoid

  ATTRIBUTES_PARAMS = [:name]

  has_many :profiles

  validates :name, presence: true
end
