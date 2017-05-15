class UsersMailer < ApplicationMailer

  def mail_by_day user_id
    @user = User.includes(:courses).find_by id: user_id
    if @user.present? && @user.courses.any?
      @courses = @user.courses
      mail to: @user.email, subject: t("mail.by_day.title", time: Date.today)
    end
  end
end
