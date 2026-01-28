class AddLayoutIdToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :maglev_pages, :layout_id, :string, null: true
    add_index :maglev_pages, :layout_id, using: :btree
  end
end
