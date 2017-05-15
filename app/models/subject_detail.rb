class SubjectDetail < ApplicationRecord
  acts_as_paranoid

  belongs_to :subject
end
