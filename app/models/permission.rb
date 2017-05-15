class Permission < ApplicationRecord
  acts_as_paranoid

  belongs_to :role
end
