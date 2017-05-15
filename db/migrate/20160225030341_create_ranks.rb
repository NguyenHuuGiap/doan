class CreateRanks < ActiveRecord::Migration
  def change
    create_table :ranks do |t|
      t.integer :begin_point
      t.integer :end_point
      t.float :rank_value

      t.timestamps null: false
    end
  end
end
