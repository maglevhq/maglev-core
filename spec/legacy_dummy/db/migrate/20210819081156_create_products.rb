# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku, unique: true
      t.float :price
      t.boolean :sold_out, default: false

      t.timestamps
    end
  end
end
