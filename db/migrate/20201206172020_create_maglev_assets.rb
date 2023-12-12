class CreateMaglevAssets < ActiveRecord::Migration[6.0]
  include Maglev::Migration
  def change
    create_table :maglev_assets, id: primary_key_type do |t|
      t.string :filename
      t.string :content_type
      t.integer :width
      t.integer :height
      t.integer :byte_size      

      t.timestamps
    end
  end
end
