class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :content
      t.boolean :is_correct
      t.references :question
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :answers, :deleted_at
  end
end
