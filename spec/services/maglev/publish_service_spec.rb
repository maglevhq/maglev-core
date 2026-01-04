# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PublishService do
  let(:service) { described_class.new }
  let(:theme) { build(:theme) }
  let(:site) { create(:site) }
  let(:site_scoped_store) { create(:sections_content_store, :site_scoped, :with_navbar) }
  let(:page) { create(:page) }
  let(:main_store) { fetch_sections_store('main', page.id) }

  subject { service.call(theme: theme, site: site, page: page) }

  context 'the page has never been published' do
    it 'creates 2 new sections content stores' do
      expect { subject }.to change { Maglev::SectionsContentStore.published.count }.by(4)
      expect(Maglev::SectionsContentStore.published.map(&:handle).sort).to eq %w[_site footer header main]
      expect(Maglev::SectionsContentStore.published.first.sections).to eq []   
      expect(Maglev::SectionsContentStore.published.second.sections).to match_array [hash_including('type' => 'jumbotron'), hash_including('type' => 'showcase')]
    end

    it 'marks the site and page as published' do
      expect { subject }.to change { site.reload.published? }.from(false).to(true).and change { page.reload.published? }.from(false).to(true)
    end

    it 'sets the page published payload' do
      subject
      expect(page.reload.published_payload).to eq({
        title_translations: { en: 'Home' },
        seo_title_translations: {},
        meta_description_translations: {},
        og_title_translations: {},
        og_description_translations: {},
        og_image_url_translations: {}
      }.with_indifferent_access)
    end
  end

  context 'the page has already been published' do
    before do      
      # very first publish
      service.call(theme: theme, site: site, page: page)

      # update the section content
      main_store.sections.dig(0, 'settings', 0)['value'] = 'Hello world!'
      main_store.save!
    end

    it 'does not create new sections content stores' do
      expect { subject }.to change { Maglev::SectionsContentStore.published.count }.by(0)
    end

    it 'updates the section content' do
      expect(main_store.reload.sections.dig(0, 'settings', 0, 'value')).to eq 'Hello world!'
    end
  end
end
