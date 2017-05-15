class CreateResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.references :test
      t.references :question
      t.references :answer
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :results, :deleted_at
  end
end
