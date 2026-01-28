# frozen_string_literal: true

require 'rails_helper'

describe Maglev::DiscardPageDraftService do
  let(:service) { described_class.new }
  let(:theme) { build(:theme) }
  let(:site) { create(:site) }
  let(:site_scoped_store) { create(:sections_content_store, :site_scoped, :with_navbar) }
  let(:page) { create(:page) }
  let(:main_store) { fetch_sections_store('main', page.id) }

  subject { service.call(theme: theme, site: site, page: page) }

  context 'when the page has never been published' do
    it 'raises UnpublishedPage error' do
      expect { subject }.to raise_error(Maglev::Errors::UnpublishedPage)
    end
  end

  context 'when the page has been published' do
    before do
      # very first publish
      Maglev::PublishService.new.call(theme: theme, site: site, page: page)

      # update the section content to create unpublished changes
      main_store.sections.dig(0, 'settings', 0)['value'] = 'Modified content'
      main_store.save!
    end

    it 'restores sections from published store' do
      published_store = Maglev::SectionsContentStore.published.find_by(handle: 'main', maglev_page_id: page.id)
      published_sections = published_store.sections_translations

      expect(main_store.reload.sections_translations).not_to eq(published_sections)

      subject

      expect(main_store.reload.sections_translations).to eq(published_sections)
    end

    it 'updates updated_at to be before published_at' do
      published_at = page.published_at
      subject

      page.reload
      expect(page.updated_at).to be_within(1.second).of(published_at)
    end

    it 'restores all layout stores and site-scoped store' do
      # Get published stores
      published_main = Maglev::SectionsContentStore.published.find_by(handle: 'main', maglev_page_id: page.id)
      published_header = Maglev::SectionsContentStore.published.find_by(handle: 'header', maglev_page_id: nil)
      published_footer = Maglev::SectionsContentStore.published.find_by(handle: 'footer', maglev_page_id: nil)
      published_site = Maglev::SectionsContentStore.published.find_by(handle: '_site', maglev_page_id: nil)

      # Modify unpublished stores
      main_store.sections.dig(0, 'settings', 0)['value'] = 'Modified'
      main_store.save!

      header_store = Maglev::SectionsContentStore.find_or_create_by(handle: 'header', maglev_page_id: nil,
                                                                    published: false) do |store|
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
      header_store.sections = [{ type: 'navbar', id: 'modified', settings: [] }]
      header_store.save!

      footer_store = Maglev::SectionsContentStore.find_or_create_by(handle: 'footer', maglev_page_id: nil,
                                                                    published: false) do |store|
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
      footer_store.sections = [{ type: 'footer', id: 'modified', settings: [] }]
      footer_store.save!

      site_store = Maglev::SectionsContentStore.find_or_create_by(handle: '_site', maglev_page_id: nil,
                                                                  published: false) do |store|
        store.sections_translations = site.locale_prefixes.index_with { |_locale| [] }
      end
      site_store.sections = [{ type: 'navbar', id: 'modified', settings: [] }]
      site_store.save!

      subject

      expect(main_store.reload.sections_translations).to eq(published_main.sections_translations)
      expect(header_store.reload.sections_translations).to eq(published_header.sections_translations)
      expect(footer_store.reload.sections_translations).to eq(published_footer.sections_translations)
      expect(site_store.reload.sections_translations).to eq(published_site.sections_translations)
    end

    it 'restores page information from published payload' do
      published_title = page.title_translations || {}
      published_seo_title = page.seo_title_translations || {}

      # Modify page information
      page.title_translations = { en: 'Modified Title' }
      page.seo_title_translations = { en: 'Modified SEO' }
      page.save!

      expect(page.title_translations).not_to eq(published_title)
      expect(page.seo_title_translations).not_to eq(published_seo_title)

      subject

      page.reload

      expect(page.title_translations).to eq(published_title)
      expect(page.seo_title_translations).to eq(published_seo_title)
    end
  end

  context 'when only site has been published but not page' do
    before do
      Maglev::PublishService.new.call(theme: theme, site: site, page: page)
      # Unpublish page by deleting its published page-scoped stores
      page.sections_content_stores.published.destroy_all
    end

    it 'raises UnpublishedPage error' do
      expect { subject }.to raise_error(Maglev::Errors::UnpublishedPage)
    end
  end
end
