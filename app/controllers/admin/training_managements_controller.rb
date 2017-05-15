class Admin::TrainingManagementsController < ApplicationController
  load_and_authorize_resource class: false

  def index
    respond_to do |format|
      format.html {add_breadcrumb_index "training_managements"}
      format.json {
        render json: TrainingManagementsDatatable.new(view_context, @namespace)
      }
    end
  end
end
