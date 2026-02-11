# frozen_string_literal: true

require 'rails_helper'

describe Maglev::HasUnpublishedChanges do
  let(:site) { build(:site) }
  let(:service) { described_class.new }
  let(:theme) { Maglev.local_themes.first }
  let(:page) { create(:page) }

  subject { service.call(site: site, page: page, theme: theme) }

  context 'page has never been published' do
    it { is_expected.to be true }
  end

  context 'page is published and all stores are up to date' do
    let(:page) { create(:page, :published, published_at: 1.minute.from_now) }

    before do
      # create published counterparts for global stores
      create(:sections_content_store, :header, :published, updated_at: 1.minute.from_now)
      create(:sections_content_store, :site_scoped, :empty, :published, updated_at: 1.minute.from_now)
    end

    it { is_expected.to be false }
  end

  context 'page metadata has unpublished changes' do
    let(:page) { create(:page, :published, published_at: 1.day.ago) }

    it { is_expected.to be true }
  end

  context 'a global store has unpublished changes' do
    let(:page) { create(:page, :published, published_at: 1.minute.from_now) }

    before do
      create(:sections_content_store, :header, published: false)
    end

    it { is_expected.to be true }
  end

  context 'the site-scoped store has unpublished changes' do
    let(:page) { create(:page, :published, published_at: 1.minute.from_now) }

    before do
      create(:sections_content_store, :site_scoped, :empty, published: false)
    end

    it { is_expected.to be true }
  end
end
