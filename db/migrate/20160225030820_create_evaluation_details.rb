class CreateEvaluationDetails < ActiveRecord::Migration
  def change
    create_table :evaluation_details do |t|
      t.string :name
      t.integer :point
      t.references :evaluation, index: true, foreign_key: true
      t.references :evaluation_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
