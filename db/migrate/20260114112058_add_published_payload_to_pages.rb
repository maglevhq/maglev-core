class AddPublishedPayloadToPages < ActiveRecord::Migration[8.1]
  def change
    add_column :maglev_pages, :published_payload, :jsonb, default: {}    
  end
end
