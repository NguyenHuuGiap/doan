class GroupSubject < ApplicationRecord
  acts_as_paranoid

  has_many :user_subjects
  has_many :users, through: :user_subjects
end
