# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionsContent do
  subject { service.call(handle: handle, locale: :en) }

  let(:site) { build(:site) }
  let(:theme) { build(:theme) }
  let(:get_page_fullpath) { double('GetPageFullPath', call: nil) }
  let(:fetch_collection_items) { double('FetchCollectionItems', call: nil) }
  let(:service) do
    described_class.new(
      fetch_site: double('FetchSite', call: site),
      fetch_theme: double('FetchTheme', call: theme),
      get_page_fullpath: get_page_fullpath,
      fetch_collection_items: fetch_collection_items
    )
  end

  context 'the store doesn\'t exist yet' do
    let(:handle) { 'unknown' }

    it { is_expected.to eq([[], 0]) }
  end

  # rubocop:disable Style/StringHashKeys
  context 'the store has some sections' do
    let!(:page) { create(:page) }
    let(:handle) { "main-#{page.id}" }

    it 'returns the sections' do
      expect(subject).to eq([[
                              {
                                'id' => 'def',
                                'type' => 'jumbotron',
                                'settings' => [
                                  { 'id' => 'title', 'value' => 'Hello world' },
                                  { 'id' => 'body', 'value' => '<p>Lorem ipsum</p>' }
                                ],
                                'blocks' => []
                              },
                              {
                                'id' => 'ghi',
                                'type' => 'showcase',
                                'settings' => [
                                  { 'id' => 'title', 'value' => 'Our projects' }
                                ], 'blocks' => [
                                  {
                                    'type' => 'showcase_item',
                                    'settings' => [
                                      { 'id' => 'name', 'value' => 'My first project' },
                                      { 'id' => 'screenshot', 'value' => '/assets/screenshot-01.png' }
                                    ]
                                  }
                                ]
                              }
                            ], 0])
    end

    context 'the section have unused settings' do
      let!(:page) { create(:page, :with_unused_settings) }
      it 'skips the unused settings' do
        expect(subject).to eq([[
                                {
                                  'id' => 'ghi',
                                  'type' => 'showcase',
                                  'settings' => [
                                    { 'id' => 'title', 'value' => 'Our projects' }
                                  ], 'blocks' => [
                                    {
                                      'type' => 'showcase_item',
                                      'settings' => [
                                        { 'id' => 'name', 'value' => 'My first project' },
                                        { 'id' => 'screenshot',
                                          'value' => '/assets/screenshot-01.png' }
                                      ]
                                    }
                                  ]
                                }
                              ], 0])
      end
    end

    context 'the sections include a link in text type setting' do
      let(:page) { create(:page, sections: nil) }
      let!(:store) { create(:sections_content_store, :page_link_in_text, page: page) }

      it 'sets the href properties' do
        expect(get_page_fullpath).to receive(:call).with(page: '42',
                                                         locale: :en).once.and_return('/preview/awesome-path')
        expect(subject[0][0]['settings'][1]['value']).to include('<a href="/preview/awesome-path"')
      end
    end

    context 'the sections include a link in link type setting' do
      let(:page) { create(:page, sections: nil) }
      let!(:store) { create(:sections_content_store, :sidebar, :page_link_in_link, page: page) }
      let(:handle) { 'sidebar' }

      it 'sets the href properties' do
        expect(get_page_fullpath).to receive(:call).with(page: '42',
                                                         locale: :en).once.and_return('/preview/awesome-path')
        expect(subject[0][0]['blocks'][0]['settings'][1]['value']['href']).to eq('/preview/awesome-path')
      end
    end

    context 'the sections include collection items' do
      let!(:page) { create(:page, :featured_product) }

      it 'fetches the product from the DB' do
        expect(fetch_collection_items).to receive(:call).with(collection_id: 'products', id: 42).and_return(
          instance_double('CollectionItem', label: 'New product name', source: 'Product fetched')
        )
        expect(subject[0][0]['settings'][1]['value']['label']).to eq('New product name')
        expect(subject[0][0]['settings'][1]['value']['item']).to eq('Product fetched')
      end

      context 'the setting content points to the any item' do
        let!(:page) { create(:page, :any_featured_product) }

        it 'fetches the first product' do
          expect(fetch_collection_items).to receive(:call).with(collection_id: 'products', id: 'any').and_return(
            instance_double('CollectionItem', label: 'New product name', source: 'Product fetched')
          )
          expect(subject[0][0]['settings'][1]['value']['label']).to eq('New product name')
          expect(subject[0][0]['settings'][1]['value']['item']).to eq('Product fetched')
        end
      end
    end

    context 'there is a mirrored section' do
      let(:another_sections_content) do
        JSON.parse([
          {
            id: 'fake-section-id',
            type: 'jumbotron',
            settings: [{ id: :title, value: 'Hello world 🤓' }, { id: :body, value: '<p>Lorem ipsum!</p>' }],
            blocks: []
          }
        ].to_json)
      end
      let(:another_page) do
        create(:page, title: 'another page', path: 'another-page', sections: another_sections_content)
      end

      let(:sections_content) do
        JSON.parse([
          {
            type: 'jumbotron',
            settings: [{ id: :title, value: '' }, { id: :body, value: '' }],
            blocks: [],
            mirror_of: {
              enabled: true,
              page_id: another_page.id,
              layout_group_id: 'main',
              section_id: 'fake-section-id'
            }
          }
        ].to_json)
      end
      let!(:page) { create(:page, sections: sections_content) }

      it 'returns the sections' do
        expect(subject).to eq([[
                                {
                                  'type' => 'jumbotron',
                                  'settings' => [
                                    { 'id' => 'title', 'value' => 'Hello world 🤓' },
                                    { 'id' => 'body', 'value' => '<p>Lorem ipsum!</p>' }
                                  ],
                                  'blocks' => [],
                                  'mirror_of' => {
                                    'enabled' => true,
                                    'page_id' => another_page.id,
                                    'layout_group_id' => 'main',
                                    'section_id' => 'fake-section-id'
                                  }
                                }
                              ], 0])
      end
    end
  end

  # rubocop:enable Style/StringHashKeys
end
