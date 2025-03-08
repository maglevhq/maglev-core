# frozen_string_literal: true

FactoryBot.define do
  factory :section_content_store, class: 'Maglev::SectionContentStore' do
    transient do
      page { nil }
    end

    handle { "main#{page ? "-#{page.id}" : ''}" }

    sections do
      [
        {
          id: 'def',
          type: 'jumbotron',
          settings: [{ id: :title, value: 'Hello world' }, { id: :body, value: '<p>Lorem ipsum</p>' }],
          blocks: []
        },
        {
          id: 'ghi',
          type: 'showcase',
          settings: [{ id: :title, value: 'Our projects' }],
          blocks: [
            {
              type: 'showcase_item',
              settings: [
                { id: :name, value: 'My first project' },
                { id: :screenshot, value: '/assets/screenshot-01.png' }
              ]
            }
          ]
        }
      ]
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
        record.find_section('navbar')['blocks'][0]['settings'][1]['value'] = {
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
  end
end
