class CreateUserNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :user_notifications do |t|
      t.boolean :seen, default: 0
      t.timestamps null: false

      t.references :user, index: true, foreign_key: true
      t.references :notification, index: true, foreign_key: true
    end
  end
end
