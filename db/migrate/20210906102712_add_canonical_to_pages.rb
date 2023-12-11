class AddCanonicalToPages < ActiveRecord::Migration[6.0]
  def change
    add_column :maglev_page_paths, :canonical, :boolean, null: true, default: true
    add_index :maglev_page_paths, %i[canonical maglev_page_id locale], unique: true, name: 'canonical_uniqueness'
  end
end
