class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.references :evaluation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :author, references: :user

      t.timestamps null: false
    end
  end
end
