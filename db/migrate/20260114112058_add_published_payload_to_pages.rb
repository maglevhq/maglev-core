class AddPublishedPayloadToPages < ActiveRecord::Migration[6.0]
  include Maglev::Migration
  def change
    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :published_payload, default: {}
      elsif mysql?
        t.json :published_payload # MySQL doesn't support default values for json columns
      else
        t.json :published_payload, default: {}
      end
    end
  end
end
