# frozen_string_literal: true

require 'rails_helper'

describe Maglev::RenameSectionType do
  subject { described_class.call(site: site, theme: theme, old_type: old_type, new_type: new_type) }

  let(:site) { create(:site, locales: [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }]) }
  let(:theme) { build(:theme) }
  let(:old_type) { 'hero' }
  let(:new_type) { 'banner' }

  before do
    allow(theme).to receive(:sections).and_return(
      double('Sections', find: true)
    )
  end

  describe 'when the site has sections of the specified type' do
    before do
      site.update!(sections_translations: {
                     en: [{ type: 'hero', settings: [{ value: 'Hello' }] }],
                     fr: [{ type: 'hero', settings: [{ value: 'Bonjour' }] }]
                   })
    end

    it 'renames the section type in all locales' do
      expect(subject).to be true

      # Check English locale
      Maglev::I18n.with_locale(:en) do
        expect(site.reload.sections.first['type']).to eq('banner')
        expect(site.sections.first['settings'].first['value']).to eq('Hello')
      end

      # Check French locale
      Maglev::I18n.with_locale(:fr) do
        expect(site.reload.sections.first['type']).to eq('banner')
        expect(site.sections.first['settings'].first['value']).to eq('Bonjour')
      end
    end
  end

  describe 'when the site has no sections of the specified type' do
    before do
      site.update!(sections_translations: {
                     en: [{ type: 'footer' }],
                     fr: [{ type: 'footer' }]
                   })
    end

    it 'does not modify the sections' do
      expect(subject).to be true

      # Check English locale
      Maglev::I18n.with_locale(:en) do
        expect(site.reload.sections.first['type']).to eq('footer')
      end

      # Check French locale
      Maglev::I18n.with_locale(:fr) do
        expect(site.reload.sections.first['type']).to eq('footer')
      end
    end
  end

  describe 'when the new section type does not exist in the theme' do
    before do
      allow(theme).to receive(:sections).and_return(
        double('Sections', find: nil)
      )
    end

    it 'raises an UnknownSection error' do
      expect { subject }.to raise_error(
        Maglev::Errors::UnknownSection,
        "New section type 'banner' doesn't exist in the theme"
      )
    end
  end

  describe 'when renaming sections across site and pages' do
    let!(:page) { create(:page) }

    before do
      # Set up sections for both site and page
      site.update!(sections_translations: {
                     en: [{ type: 'hero' }, { type: 'footer' }],
                     fr: [{ type: 'hero' }, { type: 'footer' }]
                   })

      page.update!(sections_translations: {
                     en: [{ type: 'hero' }, { type: 'navigation' }],
                     fr: [{ type: 'hero' }, { type: 'navigation' }]
                   })
    end

    it 'renames the sections in both site and pages' do
      expect(subject).to be true

      # Check site sections
      Maglev::I18n.with_locale(:en) do
        expect(site.reload.sections.map { |s| s['type'] }).to eq(%w[banner footer])
      end

      # Check page sections
      Maglev::I18n.with_locale(:en) do
        expect(page.reload.sections.map { |s| s['type'] }).to eq(%w[banner navigation])
      end
    end
  end
end
