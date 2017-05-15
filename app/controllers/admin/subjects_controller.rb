class Admin::SubjectsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :course
  skip_load_resource :course, only: :show
  skip_load_resource only: [:edit, :update]
  before_action :find_subject_in_edit, only: [:edit, :update]
  before_action :find_course_in_show, only: :show

  def index
    @subject = Subject.new
    respond_to do |format|
      format.html {add_breadcrumb_index "subjects"}
      format.json {
        render json: SubjectsDatatable.new(view_context, @namespace)
      }
    end
  end

  def show
    @course_subject = @course.course_subjects.find do |course_subject|
      course_subject.subject_id == @subject.id
    end
    @user_subjects = @course_subject.user_subjects
    @user_subjects_not_finishs = @user_subjects.not_finish @user_subjects.finish

    add_breadcrumb_path "courses"
    add_breadcrumb @course.name, admin_course_path(@course)
    add_breadcrumb @course_subject.subject_name
    load_chart_data
  end

  def new
    @subject.documents.build
    @subject.task_masters.build

    add_breadcrumb_path "subjects"
    add_breadcrumb_new "subjects"
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = flash_message "created"
      redirect_to admin_subjects_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def edit
    add_breadcrumb_path "subjects"
    add_breadcrumb @subject.name, admin_subject_task_masters_path(@subject)
    add_breadcrumb_edit "subjects"
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = flash_message "updated"
      redirect_to admin_subject_task_masters_path(@subject)
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      flash[:success] = flash_message "deleted"
    else
      flash.now[:failed] = flash_message "not_deleted"
    end
    respond_to do |format|
      format.html {redirect_to admin_subjects_path}
    end
  end

  private
  def subject_params
    params.require(:subject).permit Subject::SUBJECT_ATTRIBUTES_PARAMS
  end

  def find_subject_in_edit
    @subject = Subject.includes(:documents, :task_masters)
      .find_by_id params[:id]
    redirect_if_object_nil @subject
  end

  def find_course_in_show
    @course = Course.includes(course_subjects: [user_subjects: :user])
      .find_by_id params[:course_id]
    redirect_if_object_nil @course
  end

  def load_chart_data
    if @user_subjects.any?
      @user_tasks_chart_data = {}

      @user_subjects.each do |user_subject|
        @user_tasks_chart_data[user_subject.user.name] = user_subject
          .user_tasks.finished.size
      end
    end
  end
end
