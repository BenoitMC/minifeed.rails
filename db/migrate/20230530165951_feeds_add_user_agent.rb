class FeedsAddUserAgent < ActiveRecord::Migration[7.0]
  def change
    add_column :feeds, :user_agent, :string
  end
end
