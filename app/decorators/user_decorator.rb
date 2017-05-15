class UserDecorator < Draper::Decorator
  include ActionView::Helpers::UrlHelper
  delegate_all

  def user_course_last_actived
    courses.last
  end

  def set_link_role
    html = ""
    roles.pluck(:role_type).uniq.each do |role_type|
      case role_type
      when Settings.namespace_roles.admin
        html += "<li>" + link_to(I18n.t("user.type.admin"), Rails.application.routes.url_helpers.admin_root_path,
        class: "btn btn-default btn-flat admin") + "</li>"
      when Settings.namespace_roles.trainer
        html += "<li>" + link_to(I18n.t("user.type.trainer"), Rails.application.routes.url_helpers.trainer_root_path,
        class: "btn btn-default btn-flat trainer") + "</li>"
      when Settings.namespace_roles.trainee
        html += "<li>" + link_to(I18n.t("user.type.trainee"), Rails.application.routes.url_helpers.root_path,
        class: "btn btn-default btn-flat trainee") + "</li>"
      end
    end
    html.html_safe
  end
end
