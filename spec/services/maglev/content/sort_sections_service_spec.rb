# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::SortSectionsService do
  let(:theme) { build(:theme) }
  let(:site) { create(:site, :empty) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:lock_version) { nil }

  before do
    page.prepare_sections(theme)
    page.save! # persist sections with their assigned IDs so DB and memory are in sync
  end

  let(:jumbotron_id) { page.sections.find { |s| s['type'] == 'jumbotron' }['id'] }
  let(:showcase_id) { page.sections.find { |s| s['type'] == 'showcase' }['id'] }

  subject do
    service.call(page: page, section_ids: section_ids, lock_version: lock_version)
  end

  context 'Given page-scoped section ids (standard case)' do
    let(:section_ids) { [showcase_id, jumbotron_id] }

    it 'reorders the sections' do
      expect { subject }.to change { page.reload.sections.map { |s| s['type'] } }
        .to(%w[showcase jumbotron])
    end
  end

  context 'Given a stale lock version' do
    let(:section_ids) { [showcase_id, jumbotron_id] }
    let(:lock_version) { 1 }

    # rubocop:disable Rails/SkipsModelValidations
    before { page.update_column(:lock_version, 2) }
    # rubocop:enable Rails/SkipsModelValidations

    it 'raises an exception about the stale page' do
      expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
    end
  end

  context 'Given site-scoped section ids sent by the UI (legacy mismatched IDs)' do
    # Legacy pages store their own random ID for site-scoped sections, while the UI
    # renders and sends the site section's ID (via transform_if_site_scoped).
    # The service must translate site IDs back to page-local IDs before sorting.
    let(:site) { create(:site, :with_navbar) }
    let!(:page) { create(:page, :with_navbar) }
    let(:page_navbar_id) { 'legacy-page-navbar-id' }
    let(:site_navbar_id) { site.sections.find { |s| s['type'] == 'navbar' }['id'] }

    before do
      navbar = page.sections.find { |s| s['type'] == 'navbar' }
      navbar['id'] = page_navbar_id
      page.sections_translations_will_change!
      page.save!
    end

    let(:section_ids) { [site_navbar_id, showcase_id, jumbotron_id] }

    it 'correctly reorders sections using the site-scoped ID sent by the UI' do
      expect { subject }.to change { page.reload.sections.map { |s| s['type'] } }
        .to(%w[navbar showcase jumbotron])
    end

    it 'preserves the page-local ID in storage' do
      subject
      expect(page.reload.sections.find { |s| s['type'] == 'navbar' }['id']).to eq(page_navbar_id)
    end
  end
end
