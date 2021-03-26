# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: Maglev::Page do
    title { 'Home' }
    path { 'index' }
    sections do
      [
        { type: 'jumbotron', settings: { title: 'Hello world', body: '<p>Lorem ipsum</p>' }, blocks: [] },
        {
          type: 'showcase', settings: { title: 'Our projects' },
          blocks: [
            {
              type: 'project', settings: { name: 'My first project', screenshot: '/assets/screenshot-01.png' }
            }
          ]
        }
      ]
    end
  end
end
