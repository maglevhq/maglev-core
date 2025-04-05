class CreateMaglevSectionsContentStores < ActiveRecord::Migration[6.0]
  def change
    create_table :maglev_sections_content_stores do |t|
      t.string :handle, null: false, index: true

      t.jsonb :sections_translations, default: {}

      t.integer :lock_version

      t.timestamps
    end
  end
end
