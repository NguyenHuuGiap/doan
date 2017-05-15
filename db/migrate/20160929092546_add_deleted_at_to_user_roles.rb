class AddDeletedAtToUserRoles < ActiveRecord::Migration[5.0]
  def change
    add_column :user_roles, :deleted_at, :datetime
    add_index :user_roles, :deleted_at
  end
end
