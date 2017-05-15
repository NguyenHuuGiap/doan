class Result < ApplicationRecord
  acts_as_paranoid

  serialize :answer_id
  belongs_to :question
  belongs_to :test
end
