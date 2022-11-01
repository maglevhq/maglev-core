# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageFullpath do
  subject { service.call(page: page_or_id, locale: locale) }

  let(:site) { create(:site) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:get_base_url) { double('GetBaseUrl', call: '/maglev/preview') }
  let(:page_or_id) { page.id }
  let(:locale) { :en }
  let(:service) { described_class.new(fetch_site: fetch_site, get_base_url: get_base_url) }

  context "the page doesn't exist yet" do
    let(:page_or_id) { 42 }

    it 'returns nil' do
      expect(subject).to eq nil
    end
  end

  context 'we pass a path' do
    subject { service.call(path: 'index', locale: locale) }

    it 'returns the fullpath to the index page' do
      expect(subject).to eq '/maglev/preview'
    end

    context 'live mode' do
      let(:get_base_url) { double('GetBaseUrl', call: nil) }

      it 'returns the fullpath to the index page' do
        expect(subject).to eq '/'
      end
    end
  end

  context 'we pass the id of an existing page' do
    let!(:page) { create(:page, path: 'hello-world') }

    before do
      Maglev::I18n.with_locale(:fr) do
        page.update!(title: 'Bonjour le monde', path: 'bonjour-le-monde')
      end
    end

    it 'returns the fullpath to the page in EN (default locale)' do
      expect(subject).to eq '/maglev/preview/hello-world'
    end

    context 'asking for the full path in a different locale' do
      let(:locale) { 'fr' }

      it 'returns the fullpath to the page in FR' do
        expect(subject).to eq '/maglev/preview/fr/bonjour-le-monde'
      end
    end
  end

  context 'we pass the existing page itself' do
    subject { service.call(page: create(:page, path: 'hello-world'), locale: locale) }

    it 'returns the fullpath to the page' do
      expect(subject).to eq '/maglev/preview/hello-world'
    end
  end

  context 'we pass a static page' do
    subject { service.call(page: page, locale: locale) }

    let(:page) do
      Maglev::StaticPage.new(id: '233456abcdef', path_translations: { fr: 'bonjour-le-monde', en: 'hello-world' })
    end

    it 'returns the fullpath to the page' do
      expect(subject).to eq '/maglev/preview/hello-world'
    end
  end
end
