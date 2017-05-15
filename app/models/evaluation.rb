class Evaluation < ApplicationRecord
  acts_as_paranoid

  ATTRIBUTES_PARAMS = [:assessment, :total_point, :current_rank,
    :rank_id, :user_id, evaluation_details_attributes:
      [:id, :name, :point, :evaluation_id, :evaluation_template_id],
      notes_attributes: [:id, :name, :evaluation_id, :_destroy]
  ]

  belongs_to :user

  has_one :rank
  has_many :evaluation_details, dependent: :destroy
  has_many :notes, dependent: :destroy

  before_save :cal_total_point, :cal_rank_value

  accepts_nested_attributes_for :evaluation_details, allow_destroy: true
  accepts_nested_attributes_for :notes, allow_destroy: true,
    reject_if: proc {|attributes| attributes[:name].blank?}

  private
  def cal_total_point
    points = self.evaluation_details.map{|detail| detail.point}
    self.total_point = points.inject(0){|sum, x| sum + x}
  end

  def cal_rank_value
    unless Rank.rank_around(self.total_point).empty?
      self.current_rank = Rank.rank_around(self.total_point).take!.id
    end
  end
end
