class AddLayoutIdToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :maglev_pages, :layout_id, :string, null: true
  end
end
