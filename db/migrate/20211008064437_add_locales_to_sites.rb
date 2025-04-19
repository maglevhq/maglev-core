class AddLocalesToSites < ActiveRecord::Migration[6.0]
  def change
    change_table :maglev_sites do |t|
      if t.respond_to? :jsonb
        t.jsonb :locales, default: []
      else
        t.json :locales, default: []
      end
    end
  end
end
