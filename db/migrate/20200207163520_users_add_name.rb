class UsersAddName < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    User.update_all("name = email")
  end
end
