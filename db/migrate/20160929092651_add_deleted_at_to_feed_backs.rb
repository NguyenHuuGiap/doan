class AddDeletedAtToFeedBacks < ActiveRecord::Migration[5.0]
  def change
    add_column :feed_backs, :deleted_at, :datetime
    add_index :feed_backs, :deleted_at
  end
end
