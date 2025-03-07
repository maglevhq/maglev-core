class CreateMaglevSectionContentStores < ActiveRecord::Migration[8.0]
  def change
    create_table :maglev_section_content_stores do |t|
      t.string :handle, null: false
      t.jsonb :sections_translations, default: {}

      t.timestamps
    end
  end
end
