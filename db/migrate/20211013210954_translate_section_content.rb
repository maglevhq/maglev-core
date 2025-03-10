class TranslateSectionContent < ActiveRecord::Migration[6.0]
  def change
    remove_column :maglev_sites, :sections, :jsonb, default: []
    remove_column :maglev_pages, :sections, :jsonb, default: []

    change_table :maglev_sites do |t|
      if t.respond_to? :jsonb
        t.jsonb :sections_translations, default: {}
      else
        t.json :sections_translations, default: {}
      end
    end

    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :sections_translations, default: {}
      else
        t.json :sections_translations, default: {}
      end
    end
  end
end
