class CreateTaskMasters < ActiveRecord::Migration
  def change
    create_table :task_masters do |t|
      t.string :name
      t.text :description
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
