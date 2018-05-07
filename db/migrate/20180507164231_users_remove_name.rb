class UsersRemoveName < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
