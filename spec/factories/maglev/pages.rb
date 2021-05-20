# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: Maglev::Page do
    title { 'Home' }
    path { 'index' }
    sections do
      [
        {
          type: 'jumbotron',
          settings: [
            { id: :title, value: 'Hello world' },
            { id: :body, value: '<p>Lorem ipsum</p>' }
          ],
          blocks: []
        },
        {
          type: 'showcase',
          settings: [{ id: :title, value: 'Our projects' }],
          blocks: [
            {
              type: 'project',
              settings: [
                { id: :name, value: 'My first project' },
                { id: :screenshot, value: '/assets/screenshot-01.png' }
              ]
            }
          ]
        }
      ]
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
                type: 'project',
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
      sections do
        [
          {
            id: 'abc',
            type: 'navbar'
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
                type: 'project',
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

    trait :page_links do
      after :build do |record|
        record.sections[1]['settings'][1]['value'] =
          '<p><a href="/bar">Bar</a> - <a href="/foo" maglev-link-type="page" maglev-link-id="42">TEST</a>'
      end
    end
  end
end
