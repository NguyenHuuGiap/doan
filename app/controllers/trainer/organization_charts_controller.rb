class Trainer::OrganizationChartsController < TrainerController
  before_action :verify_trainer

  def index
    @locations = Location.includes :manager

    add_breadcrumb_index "organization_charts"
  end

  private
  include VerifyTrainer
end
