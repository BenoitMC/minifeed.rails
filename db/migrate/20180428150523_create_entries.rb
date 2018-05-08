class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :feed_id
      t.string :external_id
      t.string :name
      t.text :body
      t.string :url
      t.string :author
      t.datetime :published_at
      t.boolean :is_read, null: false, default: false
      t.boolean :is_starred, null: false, default: false
      t.timestamps

      t.index :user_id
      t.index :feed_id
      t.index :external_id
      t.index :is_read
      t.index :is_starred
    end
  end
end
