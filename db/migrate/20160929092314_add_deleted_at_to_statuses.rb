class AddDeletedAtToStatuses < ActiveRecord::Migration[5.0]
  def change
    add_column :statuses, :deleted_at, :datetime
    add_index :statuses, :deleted_at
  end
end
