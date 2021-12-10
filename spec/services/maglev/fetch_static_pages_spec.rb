# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchStaticPages do
  let(:config) do
    Maglev::Config.new.tap do |config|
      config.static_pages = static_pages
    end
  end
  let(:service) { described_class.new(config: config) }

  subject { service.call }

  describe 'no static pages in the config' do
    let(:static_pages) { nil }
    it 'returns an empty array' do
      is_expected.to eq([])
    end
  end

  describe 'localized static pages' do
    let(:static_pages) do
      [
        {
          title: { en: 'Products', fr: 'Produits' },
          path: { en: 'products', fr: '/fr/produits' }
        },
        {
          title: { en: 'Authentication', fr: 'Authentification' },
          path: { en: 'sign-in', fr: '/fr/se-connecter' }
        }
      ]
    end
    it 'returns a list of static pages in the current locale (EN)' do
      Maglev::I18n.with_locale(:en) do
        expect(subject.map(&:id)).to eq(%w[d870133f9a075477a96a58e7639d40c5 9829c12b9c383dcc9f5807c7b5b9b5a9])
        expect(subject.map(&:title)).to eq(%w[Products Authentication])
        expect(subject.map(&:path)).to eq(%w[products sign-in])
        expect(subject.map(&:seo_title)).to eq([nil, nil])
      end
    end

    it 'returns a list of static pages in a different locale' do
      Maglev::I18n.with_locale(:fr) do
        expect(subject.map(&:id)).to eq(%w[d870133f9a075477a96a58e7639d40c5 9829c12b9c383dcc9f5807c7b5b9b5a9])
        expect(subject.map(&:title)).to eq(%w[Produits Authentification])
        expect(subject.map(&:path)).to eq(%w[fr/produits fr/se-connecter])
      end
    end
  end

  describe 'static pages without locales' do
    let(:static_pages) do
      [
        { title: 'Products', path: 'products' },
        { title: 'Authentication', path: 'sign-in' }
      ]
    end

    it 'returns a list of static pages' do
      Maglev::I18n.with_locale(:en) do
        expect(subject.map(&:id)).to eq(%w[47d1d4d5275f1390f836a5b777654bed 48311f718c76e05c70030cc6a46063a7])
        expect(subject.map(&:title)).to eq(%w[Products Authentication])
        expect(subject.map(&:path)).to eq(%w[products sign-in])
      end
    end
  end
end
