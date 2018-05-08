class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :category_id
      t.string :name
      t.string :url
      t.datetime :last_update_at
      t.timestamps

      t.index :user_id
      t.index :category_id
    end
  end
end
