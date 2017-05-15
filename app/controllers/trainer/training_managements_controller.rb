class Trainer::TrainingManagementsController < TrainerController
  before_action :verify_trainer

  def index
    respond_to do |format|
      format.html {add_breadcrumb_index "training_managements"}
      format.json {
        render json: TrainingManagementsDatatable.new(view_context, @namespace)
      }
    end
  end

  private
  include VerifyTrainer
end
