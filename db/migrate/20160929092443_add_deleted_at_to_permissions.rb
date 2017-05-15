class AddDeletedAtToPermissions < ActiveRecord::Migration[5.0]
  def change
    add_column :permissions, :deleted_at, :datetime
    add_index :permissions, :deleted_at
  end
end
