class CreateMaglevSectionsContentStores < ActiveRecord::Migration[6.0]
  include Maglev::Migration
  def change
    create_table :maglev_sections_content_stores, id: primary_key_type do |t|
      t.string :container_id
      t.string :container_type
      if t.respond_to? :jsonb
        t.jsonb :sections_translations, default: {}
      else
        t.json :sections_translations, default: {}
      end
      t.boolean :published, default: false

      t.timestamps
    end

    add_index :maglev_sections_content_stores, :published
    add_index :maglev_sections_content_stores, %i[container_id container_type published], name: 'maglev_sections_content_stores_container_and_published'
    add_index :maglev_sections_content_stores, %i[container_id container_type], name: 'maglev_sections_content_stores_container'
  end
end
