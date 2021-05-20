# frozen_string_literal: true

FactoryBot.define do
  factory :site, class: Maglev::Site do
    name { 'My awesome site' }
    trait :with_navbar do
      sections do
        [
          {
            type: 'navbar',
            id: 'yyy',
            settings: [
              { id: :logo, value: 'mynewlogo.png' }
            ],
            blocks: [
              {
                type: 'menu_item',
                id: 'zzz',
                settings: [
                  { id: 'label', value: 'Home' },
                  {
                    id: 'link',
                    value: {
                      link_type: 'url', open_new_window: true, href: 'https://www.nocoffee.fr'
                    }
                  }
                ]
              }
            ]
          }
        ]
      end
    end

    trait :page_links do
      after :build do |record|
        record.find_section('navbar')['blocks'][0]['settings'][1]['value'] = {
          link_type: 'page',
          link_id: '42',
          open_new_window: true,
          href: '/path-to-something'
        }
      end
    end
  end
end
