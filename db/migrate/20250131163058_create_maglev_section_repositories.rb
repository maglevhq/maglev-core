class CreateMaglevSectionRepositories < ActiveRecord::Migration[8.0]
  def change
    create_table :maglev_section_repositories do |t|
      t.string :name

      t.jsonb :sections_translations, default: {}

      t.timestamps
    end
  end
end
