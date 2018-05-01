class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :feed_id
      t.string :external_id
      t.string :name
      t.text :body
      t.string :url
      t.datetime :published_at
      t.boolean :is_read, null: false, default: false
      t.boolean :is_starred, null: false, default: false
      t.timestamps
    end
  end
end
