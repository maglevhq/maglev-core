class UpdateSectionsContentStoresForLayoutGroups < ActiveRecord::Migration[6.0]
  def change
    change_table :maglev_sections_content_stores do |t|
      t.references :maglev_page, foreign_key: true, null: true

      t.string :handle, null: false, index: true, default: 'WIP'

      t.integer :lock_version      
    end

    add_index :maglev_sections_content_stores, [:handle, :maglev_page_id, :published], unique: true, name: 'maglev_sections_content_stores_handle_and_page_id'
  end
end
