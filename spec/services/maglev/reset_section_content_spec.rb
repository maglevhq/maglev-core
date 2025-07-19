# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ResetSectionContent do
  subject { described_class.call(site: site, theme: theme, type: type) }

  let(:site) { create(:site, locales: [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }]) }
  let(:theme) { build(:theme) }
  let(:type) { 'jumbotron' }

  describe 'when the site has sections of the specified type' do
    before do
      site.update!(sections_translations: {
                     en: [{ type: 'jumbotron', settings: [{ id: 'title', value: 'Hello' }] }],
                     fr: [{ type: 'jumbotron', settings: [{ id: 'title', value: 'Bonjour' }] }]
                   })
    end

    it 'resets the section content in all locales and returns the count' do
      # Two hero sections (one in each locale)
      expect(subject).to eq(2)

      # Check English locale
      Maglev::I18n.with_locale(:en) do
        expect(site.reload.sections.first['type']).to eq('jumbotron')
        expect(site.sections.first['settings'].first['value']).to eq('Title')
      end

      # Check French locale
      Maglev::I18n.with_locale(:fr) do
        expect(site.reload.sections.first['type']).to eq('jumbotron')
        expect(site.sections.first['settings'].first['value']).to eq('Title')
      end
    end
  end

  describe 'when the site has no sections of the specified type' do
    before do
      site.update!(sections_translations: {
                     en: [{ type: 'footer', settings: [{ value: 'Footer' }] }],
                     fr: [{ type: 'footer', settings: [{ value: 'Pied de page' }] }]
                   })
    end

    it 'does not modify the sections and returns zero' do
      expect(subject).to eq(0)

      # Check English locale
      Maglev::I18n.with_locale(:en) do
        sections = site.reload.sections
        expect(sections.length).to eq(1)
        expect(sections.first['type']).to eq('footer')
        expect(sections.first['settings'].first['value']).to eq('Footer')
      end

      # Check French locale
      Maglev::I18n.with_locale(:fr) do
        sections = site.reload.sections
        expect(sections.length).to eq(1)
        expect(sections.first['type']).to eq('footer')
        expect(sections.first['settings'].first['value']).to eq('Pied de page')
      end
    end
  end

  describe 'when the section type does not exist in the theme' do
    let(:type) { 'unknown' }

    it 'raises an UnknownSection error' do
      expect { subject }.to raise_error(
        Maglev::Errors::UnknownSection,
        "Section type 'unknown' doesn't exist in the theme"
      )
    end
  end

  describe 'when resetting sections across site and pages' do
    let!(:page) { create(:page) }

    before do
      # Set up sections for both site and page
      site.update!(sections_translations: {
                     en: [{ type: 'jumbotron', settings: [{ id: 'title', value: 'Site Hero' }] }, { type: 'footer' }],
                     fr: [{ type: 'jumbotron', settings: [{ id: 'title', value: 'Site Hero FR' }] }, { type: 'footer' }]
                   })

      page.update!(sections_translations: {
                     en: [{ type: 'jumbotron', settings: [{ id: 'title', value: 'Page Hero' }] },
                          { type: 'navigation' }],
                     fr: [{ type: 'jumbotron', settings: [{ id: 'title', value: 'Page Hero FR' }] },
                          { type: 'navigation' }]
                   })
    end

    it 'resets the sections in both site and pages and returns total count' do
      # Four hero sections total (one per locale in both site and page)
      expect(subject).to eq(4)

      # Check site sections
      Maglev::I18n.with_locale(:en) do
        sections = site.reload.sections
        expect(sections.map { |s| s['type'] }).to eq(%w[jumbotron footer])
        expect(sections.find { |s| s['type'] == 'jumbotron' }['settings'].first['value']).to eq('Title')
      end

      # Check page sections
      Maglev::I18n.with_locale(:en) do
        sections = page.reload.sections
        expect(sections.map { |s| s['type'] }).to eq(%w[jumbotron navigation])
        expect(sections.find { |s| s['type'] == 'jumbotron' }['settings'].first['value']).to eq('Title')
      end
    end
  end

  describe 'when sections are blank' do
    before do
      site.update!(sections_translations: {
                     en: [],
                     fr: []
                   })
    end

    it 'returns zero and does not modify anything' do
      expect(subject).to eq(0)

      Maglev::I18n.with_locale(:en) do
        expect(site.reload.sections).to be_empty
      end

      Maglev::I18n.with_locale(:fr) do
        expect(site.reload.sections).to be_empty
      end
    end
  end
end
