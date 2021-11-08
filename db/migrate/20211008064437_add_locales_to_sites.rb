class AddLocalesToSites < ActiveRecord::Migration[6.1]
  def change
    add_column :maglev_sites, :locales, :jsonb, default: []
  end
end
