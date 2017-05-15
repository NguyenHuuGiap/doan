class AddDeletedAtToProgrammingLanguages < ActiveRecord::Migration[5.0]
  def change
    add_column :programming_languages, :deleted_at, :datetime
    add_index :programming_languages, :deleted_at
  end
end
