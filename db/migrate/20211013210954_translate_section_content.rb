class TranslateSectionContent < ActiveRecord::Migration[6.1]
  def change
    remove_column :maglev_sites, :sections, :jsonb, default: []
    add_column :maglev_sites, :sections_translations, :jsonb, default: {}
    remove_column :maglev_pages, :sections, :jsonb, default: []
    add_column :maglev_pages, :sections_translations, :jsonb, default: {}
  end
end
