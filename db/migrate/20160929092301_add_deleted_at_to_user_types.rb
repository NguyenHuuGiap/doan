class AddDeletedAtToUserTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :user_types, :deleted_at, :datetime
    add_index :user_types, :deleted_at
  end
end
