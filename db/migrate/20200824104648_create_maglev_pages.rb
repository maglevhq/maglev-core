class CreateMaglevPages < ActiveRecord::Migration[6.0]
  def change
    create_table :maglev_pages do |t|
      t.string :title
      t.string :path
      t.string :seo_title
      t.string :meta_description
      t.boolean :visible, default: true

      t.timestamps
    end

    add_index :maglev_pages, :path, unique: true
  end
end
