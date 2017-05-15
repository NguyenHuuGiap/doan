class AddDeletedAtToEvaluationDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluation_details, :deleted_at, :datetime
    add_index :evaluation_details, :deleted_at
  end
end
