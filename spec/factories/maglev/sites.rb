# frozen_string_literal: true

FactoryBot.define do
  factory :site, class: 'Maglev::Site' do
    name { 'My awesome site' }
    locales { [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }] }

    trait :empty do
      sections { [] }
    end

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

    trait :with_footer do
      sections do
        [
          {
            type: 'footer',
            id: 'footer',
            settings: [
              { id: :copyright, value: '(c) 2022 NoCoffee SARL' }
            ],
            blocks: []
          }
        ]
      end
    end

    trait :with_style do
      style do
        [
          { type: 'color', id: 'primary_color', value: '#ff00ff' },
          { type: 'text', id: 'font_name', value: 'roboto' }
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

    trait :with_preset_navbar do
      sections do
        [
          {
            type: 'navbar',
            settings: [
              { id: :logo, value: 'mynewlogo.png' }
            ],
            blocks: [
              {
                type: 'menu_group',
                settings: [],
                children: [
                  {
                    type: 'menu_item',
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
          }
        ]
      end
    end
  end
end

# == Schema Information
#
# Table name: maglev_sites
#
#  id                    :bigint           not null, primary key
#  locales               :jsonb
#  lock_version          :integer
#  name                  :string
#  sections_translations :jsonb
#  style                 :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
