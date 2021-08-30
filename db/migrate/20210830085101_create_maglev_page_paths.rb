class CreateMaglevPagePaths < ActiveRecord::Migration[6.1]
  def change
    create_table :maglev_page_paths do |t|
      t.references :maglev_page
      t.string :locale, null: false
      t.string :value, null: false
    end

    add_index :maglev_page_paths, [:value, :locale], unique: true

    remove_column :maglev_pages, :path
  end
end
