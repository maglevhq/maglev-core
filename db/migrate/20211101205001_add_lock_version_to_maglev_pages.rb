class AddLockVersionToMaglevPages < Maglev::Migration
  def change
    add_column :maglev_sites, :lock_version, :integer
    add_column :maglev_pages, :lock_version, :integer
  end
end
