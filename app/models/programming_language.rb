class ProgrammingLanguage < ApplicationRecord
  acts_as_paranoid

  ATTRIBUTES_PARAMS = [:name]

  has_many :profiles
  has_many :courses

  validates :name, presence: true
end
