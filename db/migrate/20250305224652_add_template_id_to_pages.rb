class AddTemplateIdToPages < ActiveRecord::Migration[8.0]
  def change
    change_table :maglev_pages do |t|
      t.string :layout_id, default: 'default'
    end
  end
end
