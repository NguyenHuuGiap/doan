class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :edit
  before_action :load_data, :load_user, only: :edit

  def show
    @activities = PublicActivity::Activity.includes(:owner, :trackable)
      .user_activities(@user.id).recent.limit(20).decorate
    @user_courses = @user.user_courses
    @inprogress_course = @user_courses.course_progress.last
    @finished_courses = @user_courses.course_finished

    @user_subjects = @inprogress_course.user_subjects.includes(:course_subject)
      .order_by_course_subject if @inprogress_course

    add_breadcrumb @user.name

    @note = Note.new
    @notes = Note.load_notes @user, current_user
  end

  def edit
    @user.build_profile unless @user.profile
  end

  def update
    if @user.update_attributes user_params
      sign_in @user, bypass: true
      redirect_to @user, notice: flash_message("updated")
    else
      load_data
      flash[:alert] = flash_message "not_updated"
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit User::ATTRIBUTES_PARAMS
  end

  def load_user
    @user = User.includes(:profile).find_by_id params[:id]
    if @user.nil?
      flash[:alert] = flash_message "not_find"
      redirect_to root_path
    end
  end

  def load_data
    @universities = University.all
  end
end
