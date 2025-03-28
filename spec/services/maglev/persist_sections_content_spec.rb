# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistSectionsContent, type: :service do
  subject { service.call(site: site, page: page, sections_content: sections_content) }

  let(:site) { create(:site) }
  let!(:page) { create(:page, sections: []) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme, :basic_layouts)) }
  let(:service) { described_class.new(fetch_theme: fetch_theme) }

  let(:sections_content) do
    JSON.parse([
      {
        id: 'header',
        sections: attributes_for(:sections_content_store, :header)[:sections]
      },
      {
        id: 'main',
        sections: attributes_for(:sections_content_store)[:sections]
      },
      {
        id: 'footer',
        sections: []
      }
    ].to_json)
  end

  it 'persist the content in DB' do
    subject
    expect(section_types('header')).to eq(%w[navbar])
    expect(section_types("main-#{page.id}")).to eq(%w[jumbotron showcase])
    expect(section_types('footer')).to eq([])
  end

  it 'returns the persisted stores' do
    expect(subject.keys).to eq(%w[header main footer])
    expect(subject.values.map(&:lock_version)).to eq([1, 1, 1])
  end

  context 'Given a section is a mirror of another page/section' do
    let(:another_page) { create(:page, title: 'another page', path: 'another-page') }

    let(:sections_content) do
      JSON.parse([
        { id: 'header', sections: [] },
        {
          id: 'main',
          sections: [
            {
              type: 'jumbotron',
              settings: [{ id: :title, value: 'Hello world 🤓' }, { id: :body, value: '<p>Lorem ipsum!</p>' }],
              blocks: [],
              mirror_of: {
                enabled: true,
                page_id: another_page.id,
                layout_group_id: 'main',
                section_id: 'def'
              }
            },
          ]
        }, { id: 'footer', sections: [] }
      ].to_json)
    end

    it 'changes the content of remote section' do
      subject
      expect(fetch_sections_content("main-#{another_page.id}")[0]['settings']).to match([
        # rubocop:disable Style/StringHashKeys
        hash_including({ 'value' => 'Hello world 🤓' }),
        hash_including({ 'value' => '<p>Lorem ipsum!</p>' }),
        # rubocop:enable Style/StringHashKeys
      ])
    end

    context 'the mirrored section points to another mirrored section' do
      let(:first_page_sections) do
        JSON.parse([
            {
              id: 'fake-section-id',
              type: 'jumbotron',
              settings: [{ id: :title, value: 'Hello world 😎' }, { id: :body, value: '<p>Lorem ipsum 😎</p>' }],
              blocks: []
            },
          ].to_json)
      end
      let(:first_page) { create(:page, title: 'first page', path: 'first-page', sections: first_page_sections) }


      let(:second_page_sections) do
        JSON.parse([
            {
              id: 'fake-section-id',
              type: 'jumbotron',
              settings: [{ id: :title, value: 'Hello world 😎' }, { id: :body, value: '<p>Lorem ipsum 😎</p>' }],
              blocks: [],
              mirror_of: {
                enabled: true,
                page_id: first_page.id,
                layout_group_id: 'main',
                section_id: 'fake-section-id'
              }
            },
          ].to_json)
      end
      let(:second_page) { create(:page, title: 'second page', path: 'second-page', sections: second_page_sections) }

      let(:sections_content) do
        JSON.parse([
          { id: 'header', sections: [] },
          {
            id: 'main',
            sections: [
              {
                type: 'jumbotron',
                settings: [{ id: :title, value: 'Hello world 🤓' }, { id: :body, value: '<p>Lorem ipsum 🤓</p>' }],
                blocks: [],
                mirror_of: {
                  enabled: true,
                  page_id: second_page.id,
                  layout_group_id: 'main',
                  section_id: 'fake-section-id'
                }
              },
            ]
          }, { id: 'footer', sections: [] }
        ].to_json)
      end

      it 'changes the content of the original mirror section' do
        subject
        expect(fetch_sections_content("main-#{first_page.id}")[0]['settings']).to match([
          # rubocop:disable Style/StringHashKeys
          hash_including({ 'value' => 'Hello world 🤓' }),
          hash_including({ 'value' => '<p>Lorem ipsum 🤓</p>' }),
          # rubocop:enable Style/StringHashKeys
        ])
      end
    end
  end

  context 'Given a store has been modified while persisting the content' do
    let!(:header_store) { create(:sections_content_store, :header) }
    let(:logo_url) { header_store.reload.sections[0]['settings'][0]['value'] }

    let(:sections_content) do
      JSON.parse([
        {
          id: 'header',
          sections: attributes_for(:sections_content_store, :header)[:sections],
          lock_version: 0
        }
      ].to_json)
    end

    before do
      header_store.sections[0]['settings'][0]['value'] = 'new-logo.png'
      header_store.save
    end

    it 'raises an exception about the stale content' do
      expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
    end

    it "doesn't update the content in DB" do 
      expect { subject rescue nil }.not_to change { logo_url }
    end
  end
end
