class CreateMaglevSectionContent < ActiveRecord::Migration[6.0]
  def change
    change_table :maglev_sites do |t|
      if t.respond_to? :jsonb
        t.jsonb :sections, default: []
      elsif mysql?
        t.json :sections # MySQL doesn't support default values for json columns
      else
        t.json :sections, default: []
      end
    end

    change_table :maglev_pages do |t|
      if t.respond_to? :jsonb
        t.jsonb :sections, default: []
      elsif mysql?
        t.json :sections # MySQL doesn't support default values for json columns
      else
        t.json :sections, default: []
      end
    end
  end
end
