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

    context 'the static page path starts with a slash' do
      let(:page) do
        Maglev::StaticPage.new(id: '233456abcdef', path_translations: { fr: '/bonjour-le-monde', en: '/hello-world/' })
      end

      it 'returns the fullpath without a double slash' do
        expect(subject).to eq '/maglev/preview/hello-world'
      end
    end
  end

  describe 'normalization of the slashes' do
    subject { service.call(path: path, locale: locale) }

    let(:path) { '/hello-world' }

    context 'preview mode with a base url ending with a slash' do
      let(:get_base_url) { double('GetBaseUrl', call: '/maglev/preview/') }

      it 'joins the base url and the path with a single slash' do
        expect(subject).to eq '/maglev/preview/hello-world'
      end

      context 'index page' do
        let(:path) { 'index' }

        it 'returns the base url without the trailing slash' do
          expect(subject).to eq '/maglev/preview'
        end
      end
    end

    context 'live mode (base url is the host)' do
      let(:get_base_url) { double('GetBaseUrl', call: 'https://www.example.com') }

      it 'returns an absolute url without a double slash' do
        expect(subject).to eq 'https://www.example.com/hello-world'
      end

      context 'index page' do
        let(:path) { 'index' }

        it 'returns the host only' do
          expect(subject).to eq 'https://www.example.com'
        end
      end

      context 'in a different locale' do
        let(:locale) { 'fr' }

        it 'prefixes the path by the locale without a double slash' do
          expect(subject).to eq 'https://www.example.com/fr/hello-world'
        end
      end
    end

    context 'live mode without a request (base url is nil)' do
      let(:get_base_url) { double('GetBaseUrl', call: nil) }

      it 'returns a path starting with a single slash' do
        expect(subject).to eq '/hello-world'
      end

      context 'path with a trailing slash and inner double slashes' do
        let(:path) { 'hello//world/' }

        it 'collapses the slashes' do
          expect(subject).to eq '/hello/world'
        end
      end

      context 'index page with a leading slash' do
        let(:path) { '/index' }

        it 'returns the root path' do
          expect(subject).to eq '/'
        end
      end
    end
  end

  describe '.join' do
    it 'never emits a double slash except after the scheme' do
      expect(described_class.join('https://www.example.com/', '/fr/', '/hello-world/')).to eq(
        'https://www.example.com/fr/hello-world'
      )
      expect(described_class.join(nil, '/hello-world')).to eq '/hello-world'
      expect(described_class.join(nil)).to eq '/'
      expect(described_class.join('/maglev/preview')).to eq '/maglev/preview'
      expect(described_class.join('/maglev/preview/', nil, '')).to eq '/maglev/preview'
    end
  end
end
