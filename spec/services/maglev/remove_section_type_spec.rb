# frozen_string_literal: true

require 'rails_helper'

describe Maglev::RemoveSectionType do
  subject { described_class.call(site: site, type: type) }

  let(:site) { create(:site, locales: [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }]) }
  let(:type) { 'hero' }

  describe 'when the site has sections of the specified type' do
    before do
      site.update!(sections_translations: {
                     en: [
                       { type: 'hero', settings: [{ value: 'Hello' }] },
                       { type: 'footer', settings: [{ value: 'Footer' }] }
                     ],
                     fr: [
                       { type: 'hero', settings: [{ value: 'Bonjour' }] },
                       { type: 'footer', settings: [{ value: 'Pied de page' }] }
                     ]
                   })
    end

    it 'removes the sections of the specified type in all locales and returns the count' do
      # Two hero sections (one in each locale)
      expect(subject).to eq(2)

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

  describe 'when removing all sections of a type' do
    let!(:page) { create(:page) }

    before do
      # Set up sections for both site and page
      site.update!(sections_translations: {
                     en: [{ type: 'hero' }, { type: 'footer' }],
                     fr: [{ type: 'hero' }, { type: 'footer' }]
                   })

      page.update!(sections_translations: {
                     en: [{ type: 'hero' }, { type: 'banner' }],
                     fr: [{ type: 'hero' }, { type: 'banner' }]
                   })
    end

    it 'removes the sections from both site and pages and returns total count' do
      # Four hero sections total (one per locale in both site and page)
      expect(subject).to eq(4)

      # Check site sections
      Maglev::I18n.with_locale(:en) do
        expect(site.reload.sections.map { |s| s['type'] }).to eq(['footer'])
      end

      # Check page sections
      Maglev::I18n.with_locale(:en) do
        expect(page.reload.sections.map { |s| s['type'] }).to eq(['banner'])
      end
    end
  end
end
