# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: 'Maglev::Page' do
    title { 'Home' }
    path { 'index' }
    layout_id { 'default' }

    transient do
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
            settings: [
              { id: :title, value: 'Our projects' }
            ],
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
      header_sections {}
    end

    after(:create) do |page, evaluator|
      create(:sections_content_store, sections: evaluator.sections, page: page) if evaluator.sections
      create(:sections_content_store, sections: evaluator.header_sections) if evaluator.header_sections
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
          },
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
