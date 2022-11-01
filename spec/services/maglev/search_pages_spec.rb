# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SearchPages do
  subject { service.call(id: page_id, q: q, content_locale: content_locale, default_locale: default_locale) }

  let(:site) { create(:site) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:fetch_static_pages) { double('FetchStaticPages', call: [build(:static_page)]) }
  let(:content_locale) { 'en' }
  let(:default_locale) { 'en' }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_static_pages: fetch_static_pages) }

  let!(:persisted_pages) { [create(:page), create(:page, title: 'Features', path: 'features')] }

  describe 'Given no id or q were passed to the method' do
    let(:page_id) { nil }
    let(:q) { nil }

    it 'returns all the pages' do
      expect(subject.map(&:title)).to eq(%w[Home Features Products])
    end

    describe 'Given we change the locale' do
      let(:content_locale) { 'fr' }

      it 'returns all the pages in FR' do
        Maglev::I18n.with_locale('fr') do
          expect(subject.map(&:title)).to eq([nil, nil, 'Produits'])
        end
      end
    end
  end

  describe 'Given the q parameter was filled in' do
    let(:page_id) { nil }
    let(:q) { 'Hom' }

    it 'returns the pages matching the criteria' do
      expect(subject.map(&:title)).to eq(['Home'])
    end
  end

  describe 'Given a non nil id is passed to the method' do
    let(:q) { nil }

    describe 'Given the id belongs to a persisted page' do
      let(:page_id) { persisted_pages.first.id }

      it 'returns the persisted page' do
        expect(subject.title).to eq 'Home'
      end

      describe 'Given the id (path) points to a page in the default locale' do
        let(:page_id) { 'features' }

        describe 'Given the current locale is different from the default one' do
          let(:content_locale) { 'fr' }

          it 'returns the persisted page (used by the API for untranslated page)' do
            expect(subject.title).to eq 'Features'
          end
        end
      end
    end

    describe 'Given the id belongs to a static page' do
      let(:page_id) { 'static-page-1' }

      it 'returns the static page' do
        expect(subject.title).to eq 'Products'
      end
    end
  end
end
