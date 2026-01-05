# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::DeleteSectionService do
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:theme) { build(:theme) }
  let(:layout_id) { nil }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject { service.call(store: store, section_id: section_id, layout_id: layout_id) }

  context 'Given a section that does not exist' do
    let(:section_id) { 'not_existing' }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownSection)
    end
  end

  context 'Given an existing page section' do
    let(:section_id) { store.sections.dig(0, 'id') }

    it 'deletes the section' do
      expect(subject).to eq(true)
      expect(store.reload.section_ids).not_to include(section_id)
    end

    context 'Given the page has been modified while deleting the section' do
      # rubocop:disable Rails/SkipsModelValidations
      before do
        store # force creation of the store only for this test
        2.times { fetch_sections_store('main', page.id).touch } # force a change and so a lock version change
      end
      # rubocop:enable Rails/SkipsModelValidations

      it 'raises an exception about the stale page' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end
    end

    context 'Given the section has been declared as recoverable in the layout group' do
      let(:layout_id) { 'default' }

      before do
        theme.find_layout('default').find_group('main').recoverable = ['jumbotron']
        theme.sections.find('jumbotron').singleton = true
      end

      it 'soft deletes the section' do
        expect(subject).to eq(true)
        expect(store.reload.section_ids).to include(section_id)
        expect(store.sections.dig(0, 'deleted')).to eq(true)
      end
    end
  end

  context 'Given a site scoped section' do
    let(:store) { create(:sections_content_store, :header) }
    let!(:site_scoped_store) { create(:sections_content_store, :site_scoped, :with_navbar) }
    let(:section_id) { store.sections.dig(0, 'id') }

    it 'deletes the section only on the store' do
      expect(subject).to eq(true)
      expect(store.reload.section_ids).not_to include(section_id)
      expect(site_scoped_store.reload.section_ids).to include(section_id)
    end
  end
end
