class CreateTests < ActiveRecord::Migration[5.0]
  def change
    create_table :tests do |t|
      t.references :user_subject
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :tests, :deleted_at
  end
end
