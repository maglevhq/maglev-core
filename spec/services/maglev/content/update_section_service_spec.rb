# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::UpdateSectionService do
  subject(:service_call) { service.call(page: page, section_id: section_id, content: content) }

  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:theme) { build(:theme) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:section_id) { page.sections.dig(0, 'id') }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  context 'Given an existing page section' do
    let(:content) { { title: 'Hello world!' } }

    it 'updates the section' do
      expect(subject).to eq(true)
      expect(page.sections.dig(0, 'settings', 0, 'value')).to eq('Hello world!')
    end
  end

  context 'Given an existing site section' do
    let(:site) { create(:site, :with_navbar) }
    let(:page) { create(:page, :with_navbar) }
    let(:content) { { logo: { url: '/awesome-logo.png' } } }

    it 'updates the section' do
      expect(subject).to eq(true)
      # rubocop:disable Style/StringHashKeys
      expect(site.sections.dig(0, 'settings', 0, 'value')).to eq({ 'url' => '/awesome-logo.png' })
      # rubocop:enable Style/StringHashKeys
    end
  end
end
