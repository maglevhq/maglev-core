class AddPublishedAtToSitesAndPages < ActiveRecord::Migration[6.0]
  def change
    add_column :maglev_sites, :published_at, :datetime, default: nil
    add_column :maglev_pages, :published_at, :datetime, default: nil    
  end
end
