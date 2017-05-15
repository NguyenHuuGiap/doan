class CreateSubjectDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :subject_details do |t|
      t.integer :number_of_test
      t.integer :time_of_test
      t.integer :min_score_to_pass
      t.references :subject
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :subject_details, :deleted_at
  end
end
