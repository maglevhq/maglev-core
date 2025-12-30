# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_pages
#
#  id                            :integer          not null, primary key
#  lock_version                  :integer
#  meta_description_translations :json
#  og_description_translations   :json
#  og_image_url_translations     :json
#  og_title_translations         :json
#  published_at                  :datetime
#  published_payload             :jsonb
#  sections_translations         :jsonb
#  seo_title_translations        :jsonb
#  title_translations            :jsonb
#  visible                       :boolean          default(TRUE)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  layout_id                     :string
#
# Indexes
#
#  index_maglev_pages_on_layout_id  (layout_id)
#
FactoryBot.define do
  factory :page, class: 'Maglev::Page' do
    title { 'Home' }
    path { 'index' }
    layout_id { 'default' }
  
    transient do
      number_of_showcase_blocks { 1 }
      sections do
        [
          {
            id: 'def',
            type: 'jumbotron',
            settings: [
              { id: :title, value: 'Hello world' },
              { id: :body, value: '<p>Lorem ipsum</p>' }
            ],
            blocks: []
          },
          {
            id: 'ghi',
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
      header_sections {}
    end

    after(:create) do |page, evaluator|
      create(:sections_content_store, sections: evaluator.sections, page: page) if evaluator.sections
      create(:sections_content_store, sections: evaluator.header_sections, handle: 'header') if evaluator.header_sections
    end

    trait :published do
      published_at { 1.minute.ago }
      updated_at { 2.minutes.ago }
    end

    trait :with_navbar do
      header_sections do
        [
          {
            id: 'abc',
            type: 'navbar',
            settings: [
              { id: :logo, value: 'logo.png' }
            ],
            blocks: [
              {
                id: 'menu-item-0',
                type: 'menu_item',
                settings: [
                  { id: :label, value: 'Home' },
                  { id: :link, value: '/' }
                ]
              },
              {
                id: 'menu-item-1',
                type: 'menu_item',
                settings: [
                  { id: :label, value: 'About us' },
                  { id: :link, value: '/about-us' }
                ]
              },
              {
                id: 'menu-item-1-1',
                parent_id: 'menu-item-1',
                type: 'menu_item',
                settings: [
                  { id: :label, value: 'Our team' },
                  { id: :link, value: '/about-us/team' }
                ]
              },
              {
                id: 'menu-item-1-2',
                parent_id: 'menu-item-1',
                type: 'menu_item',
                settings: [
                  { id: :label, value: 'Our office' },
                  { id: :link, value: { href: '/about-us/office', link_type: 'url', open_new_window: true } }
                ]
              }
            ]
          }          
        ]
      end
    end

    trait :with_blank_navbar do
      header_sections do
        [
          {
            id: 'abc',
            type: 'navbar',
            settings: [
              { id: :logo, value: 'logo.png' }
            ],
            blocks: []
          },          
        ]
      end
    end

    trait :page_links do
      after :build do |record|
        record.sections[1]['settings'][1]['value'] =
          '<p><a href="/bar">Bar</a> - <a href="/foo" maglev-link-type="page" maglev-link-id="42">TEST</a>'
      end
    end

    trait :featured_product do
      sections do
        [
          {
            type: 'featured_product',
            settings: [
              { id: :title, value: 'My awesome product' },
              { id: :product, value: { id: 42 } }
            ],
            blocks: []
          }
        ]
      end
    end

    trait :any_featured_product do
      sections do
        [
          {
            type: 'featured_product',
            settings: [
              { id: :title, value: 'My awesome product' },
              { id: :product, value: 'any' }
            ],
            blocks: []
          }
        ]
      end
    end

    trait :with_unused_settings do
      sections do
        [
          {
            id: 'ghi',
            type: 'showcase',
            settings: [{ id: :title, value: 'Our projects' }, { id: :foo, value: 'foo' }],
            blocks: [
              {
                type: 'item',
                settings: [
                  { id: :title, value: 'My first project' },
                  { id: :image, value: '/assets/screenshot-01.png' },
                  { id: :bar, value: 'bar' }
                ]
              }
            ]
          }
        ]
      end
    end

    trait :with_ads do
      sections do
        [
          {
            id: 'uyt',
            type: 'ads',
            settings: [{ id: :title, value: 'Buy our nice product' }],
            blocks: []
          }
        ]
      end
    end    
  end
end
