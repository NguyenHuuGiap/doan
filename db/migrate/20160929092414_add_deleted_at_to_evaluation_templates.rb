class AddDeletedAtToEvaluationTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluation_templates, :deleted_at, :datetime
    add_index :evaluation_templates, :deleted_at
  end
end
