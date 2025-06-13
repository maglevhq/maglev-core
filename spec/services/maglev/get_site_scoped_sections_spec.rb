# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::GetSiteScopedSections, type: :service do
  let(:fetch_theme) { double('FetchTheme') }
  let(:service) { described_class.new(fetch_theme: fetch_theme) }

  describe '#call' do
    # rubocop:disable Style/StringHashKeys
    let(:section) { { 'type' => 'header' } }
    let(:transformed_section) { { 'header' => 'transformed' } }
    # rubocop:enable Style/StringHashKeys

    before do
      allow(service).to receive(:fetch_stored_sections).and_return([section])
      allow(service).to receive(:transform_section).with(section).and_return('transformed')
    end

    it 'transforms and returns the sections' do
      expect(service.call).to eq(transformed_section)
    end
  end
end
