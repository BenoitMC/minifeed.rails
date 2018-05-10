class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.uuid :user_id
      t.string :name
      t.integer :position
      t.timestamps

      t.index :user_id
    end
  end
end
