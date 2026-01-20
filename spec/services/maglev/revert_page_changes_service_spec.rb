# frozen_string_literal: true

require 'rails_helper'

describe Maglev::RevertPageChangesService do
  let(:service) { described_class.new }
  let(:site) { create(:site, :with_navbar) }
  let(:page) { create(:page) }

  subject { service.call(site: site, page: page) }

  context 'when the page has never been published' do
    it 'raises UnpublishedPage error' do
      expect { subject }.to raise_error(Maglev::Errors::UnpublishedPage)
    end
  end

  context 'when the page has been published' do
    before do
      Maglev::PublishService.new.call(site: site, page: page)
      # Modify sections to create unpublished changes
      page.sections_translations = { en: [{ type: 'hero', id: '123', settings: [] }] }
      page.save!
    end

    it 'restores sections from published store' do
      published_sections = page.sections_content_stores.published.first.sections_translations
      expect(page.sections_translations).not_to eq(published_sections)

      subject

      page.reload
      expect(page.sections_translations).to eq(published_sections)
    end

    it 'updates updated_at to be before published_at' do
      published_at = page.published_at
      subject

      page.reload
      expect(page.updated_at).to be < published_at
    end

    it 'restores both site and page sections' do
      site_published_sections = site.sections_content_stores.published.first.sections_translations
      page_published_sections = page.sections_content_stores.published.first.sections_translations

      # Modify both
      site.sections_translations = { en: [] }
      site.save!

      subject

      site.reload
      page.reload
      expect(site.sections_translations).to eq(site_published_sections)
      expect(page.sections_translations).to eq(page_published_sections)
    end
  end

  context 'when only site has been published but not page' do
    before do
      Maglev::PublishService.new.call(site: site, page: page)
      # Unpublish page by deleting its published store
      page.sections_content_stores.published.destroy_all
    end

    it 'raises UnpublishedPage error' do
      expect { subject }.to raise_error(Maglev::Errors::UnpublishedPage)
    end
  end
end
