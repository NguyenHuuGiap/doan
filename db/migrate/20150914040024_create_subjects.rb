class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :image
      t.text :description
      t.text :content
      t.integer :during_time

      t.timestamps null: false
    end
  end
end
