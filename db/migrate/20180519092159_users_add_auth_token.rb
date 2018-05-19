class UsersAddAuthToken < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true

    User.all.each do |user|
      user.update!(auth_token: User.generate_unique_secure_token)
    end
  end
end
