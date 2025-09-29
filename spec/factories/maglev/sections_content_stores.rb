# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sections_content_stores
#
#  id                    :bigint           not null, primary key
#  container_type        :string
#  published             :boolean          default(FALSE)
#  sections_translations :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  container_id          :string
#
# Indexes
#
#  index_maglev_sections_content_stores_on_published       (published)
#  maglev_sections_content_stores_container                (container_id,container_type)
#  maglev_sections_content_stores_container_and_published  (container_id,container_type,published)
#
FactoryBot.define do
  factory :sections_content_store, class: 'Maglev::SectionsContentStore' do
    container { create(:page) }
    published { true }

    transient do
      number_of_showcase_blocks { 3 }
    end

    sections do
      [
        {
          type: 'jumbotron',
          settings: [
            { id: :title, value: 'Hello world' },
            { id: :body, value: '<p>Lorem ipsum</p>' }
          ],
          blocks: []
        },
        {
          type: 'showcase',
          settings: [{ id: :title, value: 'Our projects' }],
          blocks: number_of_showcase_blocks.times.map do |i|
            {
              type: 'item',
              settings: [
                { id: :title, value: i == 0 ? 'My first project' : "My project ##{i + 1}" },
                { id: :image, value: "/assets/screenshot-0#{i + 1}.png" }
              ]
            }
          end
        }
      ]
    end
  end
end
