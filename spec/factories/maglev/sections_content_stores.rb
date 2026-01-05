# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sections_content_stores
#
#  id                    :bigint           not null, primary key
#  container_type        :string
#  handle                :string           default("WIP"), not null
#  lock_version          :integer
#  published             :boolean          default(FALSE)
#  sections_translations :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  container_id          :string
#  maglev_page_id        :bigint
#
# Indexes
#
#  index_maglev_sections_content_stores_on_handle          (handle)
#  index_maglev_sections_content_stores_on_maglev_page_id  (maglev_page_id)
#  maglev_sections_content_stores_container_and_published  (container_id,container_type,published) UNIQUE
#  maglev_sections_content_stores_handle_and_page_id       (handle,maglev_page_id,published) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (maglev_page_id => maglev_pages.id)
#
FactoryBot.define do
  factory :sections_content_store, class: 'Maglev::SectionsContentStore' do
    published { false }

    handle { 'main' }

    transient do
      number_of_showcase_blocks { 3 }
    end

    trait :published do
      published { true }
    end

    sections do
      [
        {
          id: 'jumbotron-0',
          type: 'jumbotron',
          settings: [
            { id: :title, value: 'Hello world' },
            { id: :body, value: '<p>Lorem ipsum</p>' }
          ],
          blocks: []
        },
        {
          id: 'showcase-0',
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

    trait :empty do
      sections { [] }
    end

    trait :site_scoped do
      handle { '_site' }
    end

    trait :header do
      handle { 'header' }
      sections do
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

    trait :with_navbar do
      sections do
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

    trait :footer do
      handle { 'footer' }
      sections { [] } # TODO: add a copyright section?
    end

    trait :sidebar do
      handle { 'sidebar' }
      sections do
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
              }
            ]
          }
        ]
      end
    end

    # work with the default factory
    trait :page_link_in_text do
      after :build do |record|
        record.sections[0]['settings'][1]['value'] =
          '<p><a href="/bar">Bar</a> - <a href="/foo" maglev-link-type="page" maglev-link-id="42">TEST</a>'
      end
    end

    # work with the sidebar trait
    trait :page_link_in_link do
      after :build do |record|
        record.find_section_by_type('navbar').dig('blocks', 0, 'settings', 1)['value'] = {
          link_type: 'page',
          link_id: '42',
          open_new_window: true,
          href: '/path-to-something'
        }
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
                type: 'showcase_item',
                settings: [
                  { id: :name, value: 'My first project' },
                  { id: :screenshot, value: '/assets/screenshot-01.png' },
                  { id: :bar, value: 'bar' }
                ]
              }
            ]
          }
        ]
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

    trait :mirrored_section do
      transient do
        section_id { nil }
        source_page { nil }
        source_store { nil }
      end

      sections do
        [
          {
            id: section_id,
            type: 'jumbotron',
            mirror_of: {
              enabled: true,
              page_id: source_page.id,
              layout_store_id: source_store.handle,
              section_id: section_id
            }
          }
        ]
      end
    end
  end
end
