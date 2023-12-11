class SwitchToLocalizedPageFields < ActiveRecord::Migration[6.1]
  def up
    remove_columns :maglev_pages, :title, :seo_title, :meta_description
    add_column :maglev_pages, :title_translations, :jsonb, default: {}
    add_column :maglev_pages, :seo_title_translations, :jsonb, default: {}
    add_column :maglev_pages, :meta_description_translations, :jsonb, default: {}
  end

  def down
    add_column :maglev_pages, :title, :string
    add_column :maglev_pages, :seo_title, :string
    add_column :maglev_pages, :meta_description, :string
    remove_column :maglev_pages, :title_translations
    remove_column :maglev_pages, :seo_title_translations
    remove_column :maglev_pages, :meta_description_translations
  end
end
