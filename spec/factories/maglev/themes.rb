# frozen_string_literal: true

# rubocop:disable Layout/LineLength
FactoryBot.define do
  factory :theme, class: 'Maglev::Theme' do
    id { 'simple' }
    name { 'Simple' }
    description { 'Super simple theme' }

    layouts do
      Maglev::Theme::Layout.build_many(JSON.parse([
        {
          label: 'Default',
          groups: ['header', { id: 'main', page: true, accept: %w[jumbotron showcase featured_product], recoverable: %w[jumbotron] }, 'footer']
        },
        {
          label: 'Sidebar',
          groups: [
            'header',
            { id: 'main', page: true },
            { label: 'Sidebar 😎', id: 'sidebar', accept: %w[sidebar_menu sidebar_ad] },
            'footer'
          ]
        }
      ].to_json))
    end

    after(:build) do |theme, _evaluator|
      theme.style_settings = [
        Maglev::Theme::StyleSetting.build({
          label: 'Primary color', id: 'primary_color', type: 'color', default: '#f00'
        }.with_indifferent_access),
        Maglev::Theme::StyleSetting.build({
          label: 'Font name', id: 'font_name', type: 'text', default: 'comic sans'
        }.with_indifferent_access)
      ]
      theme.sections = Maglev::Section::Store.new([
                                                    Maglev::Section.build({
                                                      theme: theme,
                                                      name: 'Navbar',
                                                      id: 'navbar',
                                                      category: 'headers',
                                                      site_scoped: true,
                                                      singleton: true,
                                                      insert_at: 'top',
                                                      settings: [{ label: 'Logo', id: 'logo', type: 'image' }],
                                                      blocks: [
                                                        {
                                                          name: 'Menu item',
                                                          type: 'menu_item',
                                                          settings: [
                                                            { label: 'Label', id: 'label', type: 'text', default: 'Menu item' },
                                                            { label: 'Link', id: 'link', type: 'link', default: '/' }
                                                          ]
                                                        }
                                                      ]
                                                    }.with_indifferent_access),
                                                    Maglev::Section.build({
                                                      theme: theme,
                                                      name: 'Jumbotron',
                                                      id: 'jumbotron',
                                                      category: 'headers',
                                                      settings: [
                                                        { label: 'Title', id: 'title', type: 'text', default: 'Title' },
                                                        { label: 'Body', id: 'body', type: 'text', html: true, line_break: true,
                                                          default: 'Body' }
                                                      ],
                                                      blocks: []
                                                    }.with_indifferent_access),
                                                    Maglev::Section.build({
                                                      theme: theme,
                                                      name: 'FeaturedProduct',
                                                      id: 'featured_product',
                                                      category: 'features',
                                                      settings: [
                                                        { label: 'Title', id: 'title', type: 'text', default: 'Title' },
                                                        { label: 'Product', id: 'product', type: 'collection_item', collection_id: 'products' }
                                                      ],
                                                      blocks: []
                                                    }.with_indifferent_access),
                                                    Maglev::Section.build({
                                                      theme: theme,
                                                      name: 'Showcase',
                                                      id: 'showcase',
                                                      category: 'features',
                                                      settings: [{ label: 'Title', id: 'title', type: 'text', default: 'My work' }],
                                                      blocks: [
                                                        {
                                                          name: 'Showcase item',
                                                          type: 'item',
                                                          settings: [
                                                            { label: 'Title', id: 'title', type: 'text', default: 'Work #1' },
                                                            { label: 'Image', id: 'image', type: 'image',
                                                              default: '/samples/images/default.svg' },
                                                            { label: 'Description', id: 'description', type: 'text',
                                                              default: 'Description' }
                                                          ]
                                                        }
                                                      ]
                                                    }.with_indifferent_access),
                                                    Maglev::Section.build({
                                                      theme: theme,
                                                      name: 'Footer',
                                                      id: 'footer',
                                                      category: 'footers',
                                                      site_scoped: true,
                                                      insert_at: 'bottom',
                                                      settings: [{ label: 'Copyright', id: 'copyright', type: 'text' }],
                                                      blocks: []
                                                    }.with_indifferent_access)
                                                  ])
    end

    trait :predefined_pages do
      pages do
        [
          {
            title: 'Home',
            path: 'index',
            layout_id: 'default',
            sections: {
              header: [
                {
                  type: 'navbar',
                  settings: {},
                  blocks: []
                },
              ],
              main: [
                {
                  type: 'jumbotron',
                  settings: {
                    "title": "Let's create the product<br/>your clients<br/>will love.",
                    "body": '<p>NoCoffee, passionated developers,<br/>creators of web applications, mobiles apps and<br/>fancy R&D projects.</p>'
                  },
                  blocks: []
                },
                {
                  type: 'showcase',
                  settings: {
                    title: 'Our projects'
                  },
                  blocks: [
                    {
                      type: 'item',
                      settings: {
                        title: 'My last project'
                      }
                    },
                    {
                      type: 'item',
                      settings: {
                        title: 'My first project'
                      }
                    }
                  ]
                }
              ]
            }            
          }.with_indifferent_access,
          {
            title: 'About us',
            path: 'about-us',
            layout_id: 'default',
            sections: {
              main: [
                {
                  type: 'jumbotron',
                  settings: {
                    "title": 'About our awesome team',
                    "body": '<p>NoCoffee, passionated developers,<br/>creators of web applications, mobiles apps and<br/>fancy R&D projects.</p>'
                  },
                  blocks: []
                }
              ]
            }
          }.with_indifferent_access,
          {
            title: 'Empty',
            path: 'empty',
            layout_id: 'default',
          }.with_indifferent_access
        ]
      end
    end

    trait :with_simple_layout do
      layouts do
        Maglev::Theme::Layout.build_many(JSON.parse([
          {
            label: 'Default',
            groups: [{ id: 'main', page: true }]
          }
        ].to_json))
      end
    end
  end
end
# rubocop:enable Layout/LineLength
