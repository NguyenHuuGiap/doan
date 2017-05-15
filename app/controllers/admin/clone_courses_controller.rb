class Admin::CloneCoursesController < ApplicationController
  load_and_authorize_resource :course
  authorize_resource class: false

  def create
    clone_course_service = CloneCourseService.new @course
    @clone_course = clone_course_service.clone_course
    if @clone_course
      flash[:success] = t "courses.confirms.clone_success"
      redirect_to [:admin, @clone_course]
    else
      flash[:failed] = t "courses.confirms.not_clone"
      redirect_to admin_courses_path
    end
  end
end
