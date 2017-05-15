class Answer < ApplicationRecord
  acts_as_paranoid

  belongs_to :question

end
