class SwitchToLocalizedPageFields < ActiveRecord::Migration[6.1]
  def up
    remove_column :maglev_pages, :title if column_exists?(:maglev_pages, :title)
    remove_column :maglev_pages, :seo_title if column_exists?(:maglev_pages, :seo_title)
    remove_column :maglev_pages, :meta_description if column_exists?(:maglev_pages, :meta_description)
      
    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :title_translations, default: {}
        t.jsonb :seo_title_translations, default: {}
        t.jsonb :meta_description_translations, default: {}
      elsif mysql?
        t.json :title_translations
        t.json :seo_title_translations
        t.json :meta_description_translations
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
