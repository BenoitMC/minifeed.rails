class FeedsRenameLastUpdateToLastImport < ActiveRecord::Migration[5.2]
  def change
    rename_column :feeds, :last_update_at, :last_import_at
  end
end
