# This migration comes from agilibox (originally 20000101000000)
class EnableAgiliboxExtensions < ActiveRecord::Migration[5.1]
  def change
    enable_extension "pgcrypto"
    enable_extension "unaccent"
    enable_extension "uuid-ossp"
  end
end
