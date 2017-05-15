class Question < ApplicationRecord
  acts_as_paranoid

  belongs_to :subject

  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :tests, through: :results

  enum level: {single: 0, multiple: 1}

  validate :validate_answers
  accepts_nested_attributes_for :answers, allow_destroy: true

  private
  def validate_answers
    count_answer_correct = self.answers.select{|answer| answer.is_correct?}.count
    if count_answer_correct < 1
      errors[:base] << "phai co it nhat 1 cau tra loi dung"
    end
  end
end
