class ShowChartsService
  def show_all_users
    array_users = []
    User.all.each do |user|
      if user.trainer_id.blank?
        array_users.push load_user_not_trainee(user)
      else
        array_users.push load_user(user)
      end
    end
    array_users
  end

  private

  def load_user user
    {
      key: user.id.to_s,
      name: user.name.to_s,
      image: user.avatar.to_s,
      trainer: User.find_by(id: user.trainer_id).name.to_s,
      parent: user.parent_path.to_s
    }
  end

  def load_user_not_trainee user
    {
      key: user.id.to_s,
      name: user.name.to_s,
      image: user.avatar.to_s,
      parent: user.parent_path.to_s
    }
  end
end
