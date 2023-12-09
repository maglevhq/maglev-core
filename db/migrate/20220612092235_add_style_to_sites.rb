class AddStyleToSites < Maglev::Migration
  def change
    change_table :maglev_sites do |t|
      t.jsonb :style, default: []
    end
  end
end
