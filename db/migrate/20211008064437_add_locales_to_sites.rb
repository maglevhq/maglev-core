class AddLocalesToSites < Maglev::Migration
  def change
    add_column :maglev_sites, :locales, :jsonb, default: []
  end
end
