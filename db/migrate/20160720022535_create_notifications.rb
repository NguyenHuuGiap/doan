class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :trackable_type
      t.integer :trackable_id
      t.integer :key
      t.timestamps null: false

      t.references :user, index: true, foreign_key: true
    end
  end
end
