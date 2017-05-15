class AddDeletedAtToTaskMasters < ActiveRecord::Migration[5.0]
  def change
    add_column :task_masters, :deleted_at, :datetime
    add_index :task_masters, :deleted_at
  end
end
