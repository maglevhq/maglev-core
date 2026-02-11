# frozen_string_literal: true

require 'rails_helper'

describe Maglev::HasUnpublishedChanges do
  let(:service) { described_class.new }
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:theme) { Maglev.local_themes.first }

  subject { service.call(site: site, page: page, theme: theme) }

  context 'neither page nor site have been published' do
    it { is_expected.to be true }
  end

  context 'both page and site are published and up to date' do
    let(:site) { create(:site, published_at: 1.minute.from_now) }
    let(:page) { create(:page, :published, published_at: 1.minute.from_now) }

    it { is_expected.to be false }
  end

  context 'site has unpublished changes' do
    let(:site) { create(:site, published_at: 1.day.ago) }
    let(:page) { create(:page, :published, published_at: 1.minute.from_now) }

    it { is_expected.to be true }
  end

  context 'page has unpublished changes' do
    let(:site) { create(:site, published_at: 1.minute.from_now) }
    let(:page) { create(:page, :published, published_at: 1.day.ago) }

    it { is_expected.to be true }
  end
end
