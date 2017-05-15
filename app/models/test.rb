class Test < ApplicationRecord
  acts_as_paranoid

  belongs_to :user_subject

  has_many :results, dependent: :destroy
  has_many :question, through: :results

  enum level: {single: 1, multiple: 2}
  enum status: { pending: 0, inprogress: 1, forward: 2, finish: 3}

  accepts_nested_attributes_for :results

  after_create :create_question_random

  def create_question_random
    self.question = self.user_subject.random_questions
  end
end
