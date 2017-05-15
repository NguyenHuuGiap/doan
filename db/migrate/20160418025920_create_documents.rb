class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string  :name
      t.string  :content
      t.integer :documentable_id
      t.string  :documentable_type
      t.timestamps null: false
    end
  end
end
