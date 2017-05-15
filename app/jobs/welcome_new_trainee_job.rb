class WelcomeNewTraineeJob < ApplicationJob
  queue_as :default

  def perform user, default_password
    UserMailer.welcome_mail(user, default_password).deliver_later
  end
end
