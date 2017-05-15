class Location < ApplicationRecord
  acts_as_paranoid

  belongs_to :manager, class_name: User.name, foreign_key: :user_id

  has_many :profiles
  has_many :courses

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :manager, presence: true, uniqueness: {case_sensitive: false}

  after_save :update_user_location

  delegate :name, to: :manager, prefix: true, allow_nil: true

  private
  def update_user_location
    manager_profile = Profile.find_or_initialize_by user_id: manager.id
    manager_profile.location_id = id
    manager_profile.save
  end
end
