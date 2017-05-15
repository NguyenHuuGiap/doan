class TrainingManagementsDatatable
  include AjaxDatatablesRails::Extensions::Kaminari

  delegate :params, :link_to, to: :@view

  def initialize view, namespace
    @view = view
    @namespace = namespace
  end

  def as_json options = {}
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: users.total_count,
      iTotalDisplayRecords: users.total_count,
      aaData: data
    }
  end

  private
  def data
    users.map.each do |user|
      [
        link_to(user.name, eval("@view.#{@namespace}_user_path(user)")),
        user.profile.user_type_name,
        user.profile.location_name ? link_to(user.profile.location_name,
          eval("@view.#{@namespace}_location_path(user.profile.location)")) : "",
        user.profile.status_name,
        user.profile.university_name,
        user.profile_graduation ? I18n.l(user.profile_graduation, format: :year_month) : "",
        user.profile.programming_language_name,
        user.profile.start_training_date ?
          I18n.l(user.profile.start_training_date, format: :default) : "",
        user.profile.leave_date ? I18n.l(user.profile.leave_date, format: :default) : "",
        user.profile.finish_training_date ?
          I18n.l(user.profile.finish_training_date, format: :default) : "",
        user.profile.ready_for_project? ? I18n.t("profiles.columns.ready_for_project.ready") :
          I18n.t("profiles.columns.ready_for_project.not_ready"),
        user.profile.contract_date ? I18n.l(user.profile.contract_date, format: :default) : "",
        user.profile_working_day,
        user.trainer ? link_to(@view.avatar_user_tag(user.trainer, "profile-user img-circle",
          Settings.image_size_20), eval("@view.#{@namespace}_user_path(user.trainer)"),
          title: user.trainer.name) : "",
        (subject = user.user_subjects.find{|s| s.current_progress}) ? subject.name : "",
        user.notes.any? ? user.notes.last.name : ""
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    @users = User.trainees.includes :trainer, :notes, user_subjects: [:course_subject],
      profile: [:status, :user_type, :location, :university, :programming_language]
    users = @users.where("users.name like :search", search: "%#{params[:sSearch]}%")
      .per_page_kaminari(page).per per_page
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : @users.size
  end
end
