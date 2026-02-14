# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::UpdateSectionService do
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:theme) { build(:theme) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:section_id) { store.sections.dig(0, 'id') }
  let(:lock_version) { nil }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject(:service_call) do
    service.call(store: store, section_id: section_id, content: content, lock_version: lock_version)
  end

  context 'Given an existing page section' do
    let(:content) { { title: 'Hello world!' } }
    let(:lock_version) { 0 }

    it 'updates the section' do
      expect(subject).to eq(true)
      expect(store.reload.sections.dig(0, 'settings', 0, 'value')).to eq('Hello world!')
      expect(store.reload.lock_version).to eq(1)
    end

    context 'Given an existing page section with a version' do
      it 'updates the section' do
        expect(subject).to eq(true)
      end

      context 'Given the store has been modified while updating the section' do
        # rubocop:disable Rails/SkipsModelValidations
        before { store.touch }
        # rubocop:enable Rails/SkipsModelValidations

        it 'raises an exception about the stale store' do
          expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
        end
      end
    end
  end

  context 'Given an existing site scoped section' do
    let(:store) { create(:sections_content_store, :header) }
    let(:site_scoped_store) { create(:sections_content_store, :header, :site_scoped) }
    let(:site_scoped_sections) { fetch_sections_content('_site') }
    let(:content) { { logo: { url: '/awesome-logo.png' } } }
    let(:lock_version) { 0 }

    before do
      store.update!(lock_version: lock_version)
      site_scoped_store.update!(lock_version: lock_version)
    end

    it 'updates the section content on the site' do
      expect(subject).to eq(true)
      # rubocop:disable Style/StringHashKeys
      expect(site_scoped_sections.dig(0, 'settings', 0, 'value')).to eq({ 'url' => '/awesome-logo.png' })
      # rubocop:enable Style/StringHashKeys
      expect(site_scoped_store.reload.lock_version).to eq(1)
    end

    it "doesn't touch the page store" do
      expect { subject }.not_to(change { store.reload.lock_version })
    end
  end
end
