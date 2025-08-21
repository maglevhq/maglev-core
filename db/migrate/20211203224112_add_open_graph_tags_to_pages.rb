class AddOpenGraphTagsToPages < ActiveRecord::Migration[6.0]
  def change
    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :og_title_translations, default: {}
        t.jsonb :og_description_translations, default: {}
        t.jsonb :og_image_url_translations, default: {}
      elsif mysql?
        t.json :og_title_translations
        t.json :og_description_translations
        t.json :og_image_url_translations
      else
        t.json :og_title_translations, default: {}
        t.json :og_description_translations, default: {}
        t.json :og_image_url_translations, default: {}
      end
    end
  end
end
