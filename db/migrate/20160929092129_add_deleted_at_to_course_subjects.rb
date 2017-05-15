class AddDeletedAtToCourseSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :course_subjects, :deleted_at, :datetime
    add_index :course_subjects, :deleted_at
  end
end
