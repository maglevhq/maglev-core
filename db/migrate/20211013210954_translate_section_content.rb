class TranslateSectionContent < ActiveRecord::Migration[6.0]
  def change
    remove_column :maglev_sites, :sections, :jsonb, default: [] if column_exists?(:maglev_sites, :sections)
    remove_column :maglev_pages, :sections, :jsonb, default: [] if column_exists?(:maglev_pages, :sections)

    change_table :maglev_sites do |t|
      if t.respond_to? :jsonb
        t.jsonb :sections_translations, default: {}
      elsif mysql?
        t.json :sections_translations # MySQL doesn't support default values for json columns
      else
        t.json :sections_translations, default: {}
      end
    end

    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :sections_translations, default: {}
      elsif mysql?
        t.json :sections_translations # MySQL doesn't support default values for json columns
      else
        t.json :sections_translations, default: {}
      end
    end
  end
end
