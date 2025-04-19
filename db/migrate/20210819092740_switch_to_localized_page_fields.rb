class SwitchToLocalizedPageFields < ActiveRecord::Migration[6.1]
  def up
    remove_columns :maglev_pages, :title, :seo_title, :meta_description

    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :title_translations, default: {}
        t.jsonb :seo_title_translations, default: {}
        t.jsonb :meta_description_translations, default: {}
      else
        t.json :title_translations, default: {}
        t.json :seo_title_translations, default: {}
        t.json :meta_description_translations, default: {}
      end
    end
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
