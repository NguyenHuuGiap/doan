class AddParentPathToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :parent_path, :integer
  end
end
