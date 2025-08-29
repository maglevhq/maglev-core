# frozen_string_literal: true

require 'rails_helper'

describe Maglev::TranslatePage do
  subject { service.call(page: page, locale: 'fr', source_locale: 'en') }

  let(:site) { create(:site) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let!(:page) { create(:page, :with_navbar) }

  context 'When the site has un-translated sections' do
    let(:site) { create(:site, :with_navbar) }

    it 'translates the site attributes into the given locale' do
      subject
      expect(site.sections_translations.dig('fr', 0, 'blocks', 0, 'settings', 0, 'value')).to eq 'Home [FR]'
    end
  end

  context 'When the site has translated sections' do
    let(:site) do
      create(:site, :with_navbar,
             sections_translations: { fr: [
               { type: 'navbar',
                 blocks: [{ type: 'menu_item', settings: [{ id: 'label', value: 'Accueil' }] }] }
             ] })
    end

    it 'doesn\'t touch the existing translations' do
      subject
      expect(site.sections_translations.dig('fr', 0, 'blocks', 0, 'settings', 0, 'value')).to eq 'Accueil'
    end
  end

  # rubocop:disable Style/StringHashKeys
  it 'translates the page attributes into the given locale' do
    expect(subject.title_translations).to eq({ 'en' => 'Home', 'fr' => 'Home [FR]' })
    expect(subject.sections_translations.dig('fr', 1, 'settings', 0, 'value')).to eq 'Hello world [FR]'
  end
  # rubocop:enable Style/StringHashKeys
end
