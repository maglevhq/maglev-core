class AddStyleToSites < ActiveRecord::Migration[6.0]
  def change
    change_table :maglev_sites do |t|
      if t.respond_to? :jsonb
        t.jsonb :style, default: []
      else
        t.json :style, default: []
      end
    end
  end
end
