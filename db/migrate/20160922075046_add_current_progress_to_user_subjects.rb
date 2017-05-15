class AddCurrentProgressToUserSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :user_subjects, :current_progress, :boolean, default: false
  end
end
