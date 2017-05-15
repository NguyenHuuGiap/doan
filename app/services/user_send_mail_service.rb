class UserSendMailService
  def initialize user
    @user = user
  end

  def send_welcome_mail
    WelcomeNewTraineeJob.perform_now(@user, Settings.default_password) if Rails.env.production?
  end
end
