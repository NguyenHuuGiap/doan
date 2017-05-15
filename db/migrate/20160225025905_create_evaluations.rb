class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.string :assessment
      t.integer :total_point
      t.float :current_rank
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
