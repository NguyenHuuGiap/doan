class AddStatusToTests < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :status, :integer
  end
end
