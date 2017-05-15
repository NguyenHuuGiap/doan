module VerifyTrainer
  def verify_trainer
    if current_user.nil?
      flash[:alert] = t "flashs.user.mustlogin"
      redirect_to root_path
    elsif !current_user.is_trainer?
      flash[:alert] = t "error.not_authorize"
      redirect_to trainer_root_path
    end
  end
end
