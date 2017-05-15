class AddDeletedAtToUserCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :user_courses, :deleted_at, :datetime
    add_index :user_courses, :deleted_at
  end
end
