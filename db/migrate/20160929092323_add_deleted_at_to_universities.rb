class AddDeletedAtToUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :deleted_at, :datetime
    add_index :universities, :deleted_at
  end
end
