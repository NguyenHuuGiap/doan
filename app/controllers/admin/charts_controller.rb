class Admin::ChartsController < ApplicationController
  load_and_authorize_resource class: false

  def index
    @user_service = ShowChartsService.new.show_all_users
  end

  def update
  end
end
