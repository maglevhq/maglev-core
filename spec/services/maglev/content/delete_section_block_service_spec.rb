# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::DeleteSectionBlockService do
  let(:theme) { build(:theme) }
  let(:site) { create(:site) }
  let(:page) { create(:page) }
  let(:section_id) { page.sections.dig(1, 'id') }
  let(:block_id) { page.sections.dig(1, 'blocks', 0, 'id') }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  before { page.prepare_sections(theme) }

  subject { service.call(page: page, section_id: section_id, block_id: block_id) }

  it 'deletes the block' do
    expect { subject }.to change(page.sections.dig(1, 'blocks'), :size).by(-1)
  end
end
