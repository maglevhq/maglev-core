# frozen_string_literal: true

# rubocop:disable Layout/LineLength
FactoryBot.define do
  factory :theme, class: Maglev::Theme do
    id { 'simple' }
    name { 'Simple' }
    description { 'Super simple theme' }
        
    after(:build) do |theme, evaluator| 
      theme.sections = Maglev::Section::Store.new([
                                   Maglev::Section.build({
                                     theme: theme,
                                     name: 'Navbar',
                                     id: 'navbar',
                                     category: 'headers',
                                     scope: 'site',
                                     settings: [{ label: 'Logo', id: 'logo', type: 'image_picker' }],
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
                                       { label: 'Title', id: 'title', type: 'text', defautl: 'Title' },
                                       { label: 'Body', id: 'body', type: 'text', html: true, line_break: true,
                                         default: 'Body' }
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
                                         name: 'Menu item',
                                         type: 'menu_item',
                                         settings: [
                                           { label: 'Title', id: 'title', type: 'text', default: 'Work #1' },
                                           { label: 'Image', id: 'image', type: 'image_picker',
                                             default: '/samples/images/default.svg' },
                                           { label: 'Description', id: 'description', type: 'text',
                                             default: 'Description' }
                                         ]
                                       }
                                     ]
                                   }.with_indifferent_access)
                                 ])
    end

    trait :predefined_pages do
      pages do
        [
          {
            title: 'Home',
            path: 'index',
            sections: [
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
                blocks: []
              }
            ]
          },
          {
            title: 'About us',
            path: 'about-us',
            sections: [
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
        ]
      end
    end

    trait :with_sections_path do
      sections_path { 'theme' }
    end
  end
end
# rubocop:enable Layout/LineLength
