FactoryBot.define do
  factory :maglev_section_repository, class: 'Maglev::SectionRepository' do
    name { 'top_sidebar' }

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
  end
end
