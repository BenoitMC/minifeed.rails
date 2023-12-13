class EntriesSearch < ActiveRecord::Migration[7.1]
  def change
    enable_extension "btree_gin"
    enable_extension "pg_trgm"

    add_column :entries, :name_for_search, :string
    add_column :entries, :keywords_for_search, :text

    add_index :entries, "user_id, name_for_search gin_trgm_ops", name: "index_entries_on_name_for_search", using: :gin
    add_index :entries, "user_id, keywords_for_search gin_trgm_ops", name: "index_entries_on_keywords_for_search", using: :gin

    reversible do |direction|
      direction.up do
        execute <<~SQL
          UPDATE entries SET name_for_search = UNACCENT(name)
        SQL

        execute <<~SQL
          UPDATE entries SET keywords_for_search =
          UNACCENT(COALESCE(name, '') || ' ' || COALESCE(author, '') || ' ' || COALESCE(body, ''))
        SQL
      end
    end
  end
end
