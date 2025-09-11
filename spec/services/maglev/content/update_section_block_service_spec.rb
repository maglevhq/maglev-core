# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::UpdateSectionBlockService do
  subject(:service_call) { service.call(page: page, section_id: section_id, block_id: block_id, content: content) }

  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:section_id) { page.sections.dig(1, 'id') } # showcase section

  before { page.prepare_sections(fetch_theme.call) }

  context 'Given an existing page section block' do
    let(:block_id) { page.sections.dig(1, 'blocks', 0, 'id') }
    let(:content) { { title: 'My first project [UPDATED]' } }

    it 'updates the section block' do
      expect { subject }.to change {
        page.sections.dig(1, 'blocks', 0, 'settings', 0, 'value')
      }.to('My first project [UPDATED]')
    end
  end
end
