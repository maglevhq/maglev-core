# frozen_string_literal: true

require 'rails_helper'

describe Maglev::TranslatePage do
  subject { service.call(page: page, locale: 'fr', source_locale: 'en') }

  let(:site) { create(:site) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:service) { described_class.new(fetch_theme: fetch_theme) }
  let!(:page) { create(:page, :with_navbar) }

  # rubocop:disable Style/StringHashKeys
  it 'translates the page attributes into the given locale' do
    expect(subject.title_translations).to eq({ 'en' => 'Home', 'fr' => 'Home [FR]' })
    expect(subject.sections_translations.dig('fr', 1, 'settings', 0, 'value')).to eq 'Hello world [FR]'
  end
  # rubocop:enable Style/StringHashKeys
end
