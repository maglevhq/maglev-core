# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::SortSectionsService do
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:theme) { build(:theme) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:section_ids) { store.section_ids.reverse }
  let(:lock_version) { 0 }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject(:service_call) do
    service.call(store: store, section_ids: section_ids, lock_version: lock_version)
  end

  it 'sorts the sections' do
    expect(subject).to eq(true)
    expect(store.reload.section_ids).to eq(section_ids)
  end
end
