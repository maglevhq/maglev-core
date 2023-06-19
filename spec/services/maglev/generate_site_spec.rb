# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GenerateSite do
  subject { service.call(theme: theme) }

  let(:theme) { build(:theme, :predefined_pages) }
  let(:service) { described_class.new }

  it 'creates a new site' do
    expect do
      expect(subject.default_locale.label).to eq 'English'
    end.to change(Maglev::Site, :count).by(1)
                                       .and change(Maglev::Page, :count).by(3)
  end

  context 'Given Maglev was set up to be used with 2 locales' do
    let(:home_page) { Maglev::Page.first }

    it 'sets the same page title for all the locales' do
      subject
      # rubocop:disable Style/StringHashKeys
      expect(Maglev::Page.pluck(:title_translations)).to eq(
        [
          { 'en' => 'Home', 'fr' => 'Home' },
          { 'en' => 'About us', 'fr' => 'About us' },
          { 'en' => 'Empty', 'fr' => 'Empty' }
        ]
      )
      # rubocop:enable Style/StringHashKeys
    end

    it 'sets the same sections for all the locales' do
      subject
      Maglev::I18n.with_locale(:en) do
        expect(home_page.sections.last['settings'][0]['value']).to eq 'Our projects'
      end
      Maglev::I18n.with_locale(:fr) do
        expect(home_page.sections.last['settings'][0]['value']).to eq 'Our projects'
      end
    end
  end
end
