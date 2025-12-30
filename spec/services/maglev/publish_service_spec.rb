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
      expect(Maglev::SectionsContentStore.published.map(&:handle)).to eq %w[header main footer _site]
      expect(site.published?).to eq true
      expect(page.published?).to eq true
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
      service.call(theme: theme, site: site, page: page)
    end

    it 'does not create new sections content stores' do
      expect { subject }.to change { Maglev::SectionsContentStore.published.count }.by(0)
    end
  end
end
