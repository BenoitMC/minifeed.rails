class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :category_id
      t.string :name
      t.string :url
      t.datetime :last_import_at
      t.integer :import_errors, null: false, default: 0
      t.timestamps
      t.text :blacklist
      t.text :whitelist

      t.index :user_id
      t.index :category_id
    end
  end
end
