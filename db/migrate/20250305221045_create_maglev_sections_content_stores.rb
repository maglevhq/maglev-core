class CreateMaglevSectionsContentStores < ActiveRecord::Migration[6.0]
  def change
    create_table :maglev_sections_content_stores do |t|
      t.references :maglev_page, foreign_key: true, null: true

      t.string :handle, null: false, index: true

      if t.respond_to? :jsonb
        t.jsonb :sections_translations, default: {}
      else
        t.json :sections_translations, default: {}
      end

      t.integer :lock_version

      t.timestamps
    end
  end
end
