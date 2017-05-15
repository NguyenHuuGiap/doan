class UserCoursesController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: :show
  before_action :find_user_course, only: :show

  def show
    @course = @user_course.course
    @users = @course.users
    @user_subjects = @user_course.user_subjects.includes(course_subject: :subject).order_by_course_subject
    @trainers = @users.trainers
    @trainees = @users.trainees
    @members = @users.show_members
    @count_member = @users.size - Settings.number_member_show

    @number_of_user_subjects = @user_subjects.size
    @user_subject_statuses = UserSubject.statuses
    @user_subject_statuses.each do |key, value|
      instance_variable_set "@number_of_user_subject_#{key}", @user_subjects.send(key).size
    end
  end

  private
  def find_user_course
    @user_course = UserCourse.includes(:course).find_by_id params[:id]
    if @user_course.nil?
      flash[:alert] = flash_message "not_load"
      redirect_to courses_path
    end
  end
end
