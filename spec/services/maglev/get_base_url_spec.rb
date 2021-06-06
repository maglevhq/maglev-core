# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetBaseUrl do
  let!(:site) { create(:site) }
  let(:service) do
    described_class.new(
      fetch_site: double('FetchSite', call: build(:site)),
      context: double('Context', preview_mode?: preview_mode, controller: controller)
    )
  end
  subject { service.call }

  context 'not in preview mode' do
    let(:preview_mode) { false }
    let(:controller) { double('Controller', site_preview_path: '/maglev/preview') }
    it 'returns nil' do
      is_expected.to eq nil
    end
  end

  context 'in preview mode' do
    let(:preview_mode) { true }
    let(:controller) { double('Controller', site_preview_path: '/maglev/preview') }
    it 'returns the preview path' do
      is_expected.to eq '/maglev/preview'
    end
  end
end
