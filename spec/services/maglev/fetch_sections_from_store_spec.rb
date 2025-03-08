# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionsFromStore do
  subject { service.call(handle: handle, locale: :en) }

  let(:site) { build(:site) }
  let(:theme) { build(:theme, :basic_layouts) }
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

    it { is_expected.to eq([]) }
  end

  # rubocop:disable Style/StringHashKeys
  context 'the store has some sections' do
    let(:page) { create(:page) }
    let(:handle) { "main-#{page.id}" }

    let!(:store) { create(:section_content_store, page: page) }

    it 'returns the sections' do
      expect(subject).to eq([
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
      ])
    end

    context 'the section have unused settings' do
      let!(:store) { create(:section_content_store, :with_unused_settings, page: page) }
      it 'skips the unused settings' do
        expect(subject).to eq([
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
                              ])
      end
    end

    context 'the sections include a link in text type setting' do
      let!(:store) { create(:section_content_store, :page_link_in_text, page: page) }

      it 'sets the href properties' do
        expect(get_page_fullpath).to receive(:call).with(page: '42',
                                                         locale: :en).once.and_return('/preview/awesome-path')
        expect(subject[0]['settings'][1]['value']).to include('<a href="/preview/awesome-path"')
      end
    end

    context 'the sections include a link in link type setting' do
      let!(:store) { create(:section_content_store, :sidebar, :page_link_in_link) }
      let(:handle) { 'sidebar' }

      it 'sets the href properties' do
        expect(get_page_fullpath).to receive(:call).with(page: '42',
                                                         locale: :en).once.and_return('/preview/awesome-path')
        expect(subject[0]['blocks'][0]['settings'][1]['value']['href']).to eq('/preview/awesome-path')
      end
    end

    context 'the sections include collection items' do
      let!(:store) { create(:section_content_store, :featured_product, page: page) }

      it 'fetches the product from the DB' do
        expect(fetch_collection_items).to receive(:call).with(collection_id: 'products', id: 42).and_return(
          instance_double('CollectionItem', label: 'New product name', source: 'Product fetched')
        )
        expect(subject[0]['settings'][1]['value']['label']).to eq('New product name')
        expect(subject[0]['settings'][1]['value']['item']).to eq('Product fetched')
      end

      context 'the setting content points to the any item' do
        let!(:store) { create(:section_content_store, :any_featured_product, page: page) }

        it 'fetches the first product' do
          expect(fetch_collection_items).to receive(:call).with(collection_id: 'products', id: 'any').and_return(
            instance_double('CollectionItem', label: 'New product name', source: 'Product fetched')
          )
          expect(subject[0]['settings'][1]['value']['label']).to eq('New product name')
          expect(subject[0]['settings'][1]['value']['item']).to eq('Product fetched')
        end
      end
    end
  end  

  # rubocop:enable Style/StringHashKeys
end
