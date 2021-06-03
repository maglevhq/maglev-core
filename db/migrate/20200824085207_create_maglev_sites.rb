class CreateMaglevSites < ActiveRecord::Migration[6.0]
  def change
    create_table :maglev_sites do |t|
      t.string :name
      t.timestamps
    end
  end
end
