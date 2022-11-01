# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchStaticPages do
  subject { service.call }

  let(:config) do
    Maglev::Config.new.tap do |config|
      config.static_pages = static_pages
    end
  end
  let(:service) { described_class.new(config: config) }

  describe 'no static pages in the config' do
    let(:static_pages) { nil }

    it 'returns an empty array' do
      expect(subject).to eq([])
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
        expect(subject.map(&:id)).to eq(%w[d6e53783538bd10eaa24f654d88a84b4 24ba6bc2acc3cee432e57c75f4fb286b])
        expect(subject.map(&:title)).to eq(%w[Products Authentication])
        expect(subject.map(&:path)).to eq(%w[products sign-in])
        expect(subject.map(&:seo_title)).to eq([nil, nil])
      end
    end

    it 'returns a list of static pages in a different locale' do
      Maglev::I18n.with_locale(:fr) do
        expect(subject.map(&:id)).to eq(%w[d6e53783538bd10eaa24f654d88a84b4 24ba6bc2acc3cee432e57c75f4fb286b])
        expect(subject.map(&:title)).to eq(%w[Produits Authentification])
        expect(subject.map(&:path)).to eq(%w[/fr/produits /fr/se-connecter])
      end
    end
  end

  describe 'static pages without locales' do
    let(:static_pages) do
      [
        { title: 'Products', path: '/products' },
        { title: 'Authentication', path: '/sign-in' }
      ]
    end

    it 'returns a list of static pages' do
      Maglev::I18n.with_locale(:en) do
        expect(subject.map(&:id)).to eq(%w[a97dab6181e03029acd9b787c071fd79 c553c5c710e821b8577583ce0f41de06])
        expect(subject.map(&:title)).to eq(%w[Products Authentication])
        expect(subject.map(&:path)).to eq(%w[/products /sign-in])
      end
    end
  end
end
