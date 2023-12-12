class CreateMaglevPagePaths < ActiveRecord::Migration[6.0]
  include Maglev::Migration
  def change
    create_table :maglev_page_paths, id: primary_key_type do |t|
      t.references :maglev_page, type: foreign_key_type
      t.string :locale, null: false
      t.string :value, null: false
    end

    add_index :maglev_page_paths, [:value, :locale], unique: true

    remove_column :maglev_pages, :path, :string
  end
end
