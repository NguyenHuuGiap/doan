class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :image
      t.text :description
      t.integer :status, default: 0
      t.integer :programming_language_id
      t.date :start_date
      t.date :end_date
      t.timestamps null: false
    end
  end
end
