class FeedsAddBlackAndWhiteLists < ActiveRecord::Migration[5.2]
  def change
    add_column :feeds, :blacklist, :text
    add_column :feeds, :whitelist, :text
  end
end
