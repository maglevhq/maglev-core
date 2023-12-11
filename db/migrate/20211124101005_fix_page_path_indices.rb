class FixPagePathIndices < ActiveRecord::Migration[6.0]
  def change
    remove_index :maglev_page_paths, %i[canonical maglev_page_id locale value], unique: true, name: 'canonical_uniqueness'
    add_index :maglev_page_paths, %i[canonical maglev_page_id locale], name: 'scoped_canonical_speed'
  end
end
