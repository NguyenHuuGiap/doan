class CreateEvaluationTemplates < ActiveRecord::Migration
  def change
    create_table :evaluation_templates do |t|
      t.string :name
      t.integer :min_point
      t.integer :max_point

      t.timestamps null: false
    end
  end
end
