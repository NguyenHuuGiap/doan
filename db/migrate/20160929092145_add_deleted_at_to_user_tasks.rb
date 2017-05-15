class AddDeletedAtToUserTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :user_tasks, :deleted_at, :datetime
    add_index :user_tasks, :deleted_at
  end
end
