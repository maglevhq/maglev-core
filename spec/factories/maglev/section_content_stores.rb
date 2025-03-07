FactoryBot.define do
  factory :section_content_store, class: 'Maglev::SectionContentStore' do
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
end
