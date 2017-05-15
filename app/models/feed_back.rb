class FeedBack < ApplicationRecord
  acts_as_paranoid

  FEED_BACK_ATTRIBUTES_PARAMS = [:content]

  belongs_to :user

  validates :content, presence: true

  scope :order_by_time, ->{includes(:user).order created_at: :desc}

  delegate :name, to: :user, prefix: true, allow_nil: true
end
