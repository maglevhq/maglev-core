# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageSections do
  let(:site) { create(:site, :with_navbar) }
  let(:get_page_fullpath) { double('GetPageFullPath', call: nil) }
  let(:service) do
    described_class.new(
      fetch_site: double('FetchSite', call: site),
      fetch_theme: double('FetchTheme', call: build(:theme)),
      get_page_fullpath: get_page_fullpath
    )
  end
  subject { service.call(page: page) }

  context 'the page has no sections' do
    let(:page) { build(:page, sections: []) }
    it 'returns an empty array' do
      is_expected.to eq([])
    end
  end

  # rubocop:disable Style/StringHashKeys
  context 'the page is full of sections' do
    let(:page) { build(:page, :with_navbar) }
    it 'fetches the content of the site scoped sections of a page from the site' do
      is_expected.to eq([
                          {
                            'id' => 'abc',
                            'type' => 'navbar',
                            'settings' => [{ 'id' => 'logo', 'value' => 'mynewlogo.png' }],
                            'blocks' => [
                              {
                                'id' => 'zzz',
                                'type' => 'menu_item',
                                'settings' => [
                                  { 'id' => 'label', 'value' => 'Home' },
                                  {
                                    'id' => 'link',
                                    'value' => {
                                      'href' => 'https://www.nocoffee.fr',
                                      'link_type' => 'url',
                                      'open_new_window' => true
                                    }
                                  }
                                ]
                              }
                            ]
                          },
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
                                'type' => 'project',
                                'settings' => [
                                  { 'id' => 'name', 'value' => 'My first project' },
                                  { 'id' => 'screenshot', 'value' => '/assets/screenshot-01.png' }
                                ]
                              }
                            ]
                          }
                        ])
    end
    context "the site doesn't have a global content" do
      let(:site) { create(:site) }
      it 'fallbacks to the page version of the site scoped section' do
        is_expected.to eq([
                            {
                              'id' => 'abc',
                              'type' => 'navbar',
                              'settings' => [{ 'id' => 'logo', 'value' => 'logo.png' }],
                              'blocks' => []
                            },
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
                                  'type' => 'project',
                                  'settings' => [
                                    { 'id' => 'name', 'value' => 'My first project' },
                                    { 'id' => 'screenshot', 'value' => '/assets/screenshot-01.png' }
                                  ]
                                }
                              ]
                            }
                          ])
      end
    end
    context 'the sections include links' do
      let(:site) { create(:site, :with_navbar, :page_links) }
      let(:page) { build(:page, :with_navbar, :page_links) }
      it 'sets the href properties' do
        expect(get_page_fullpath).to receive(:call).with(page: '42').twice.and_return('/preview/awesome-path')
        expect(subject[0]['blocks'][0]['settings'][1]['value']['href']).to eq('/preview/awesome-path')
        expect(subject[1]['settings'][1]['value']).to include('<a href="/preview/awesome-path"')
      end
    end
  end
  # rubocop:enable Style/StringHashKeys
end
