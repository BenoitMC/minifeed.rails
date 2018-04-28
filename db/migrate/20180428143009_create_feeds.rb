class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :category_id
      t.string :name
      t.string :url
      t.timestamps
    end
  end
end
