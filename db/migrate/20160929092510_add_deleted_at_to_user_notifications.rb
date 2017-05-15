class AddDeletedAtToUserNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :user_notifications, :deleted_at, :datetime
    add_index :user_notifications, :deleted_at
  end
end
