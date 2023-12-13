class EntriesBetterIndexes < ActiveRecord::Migration[7.1]
  def change
    remove_index :entries, :user_id
    remove_index :entries, :feed_id
    remove_index :entries, :is_read
    remove_index :entries, :is_starred
    remove_index :entries, :external_id

    add_index :entries, [:user_id, :published_at]
    add_index :entries, [:user_id, :is_read, :published_at]
    add_index :entries, [:user_id, :is_starred, :published_at]
    add_index :entries, [:user_id, :feed_id, :is_read, :published_at]
    add_index :entries, [:user_id, :feed_id, :published_at]
    add_index :entries, [:user_id, :external_id]
  end
end
