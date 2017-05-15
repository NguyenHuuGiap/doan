class AddDeletedAtToUserSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :user_subjects, :deleted_at, :datetime
    add_index :user_subjects, :deleted_at
  end
end
