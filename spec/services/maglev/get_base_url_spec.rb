# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetBaseUrl do
  let!(:site) { create(:site) }
  let(:service) do
    described_class.new(
      fetch_site: double('FetchSite', call: build(:site)),
      context: double('Context', rendering_mode: rendering_mode, controller: controller)
    )
  end
  subject { service.call }

  context 'rendering the live page' do
    let(:rendering_mode) { :live }
    let(:controller) { double('Controller', site_preview_path: '/maglev/preview') }
    it 'returns nil' do
      is_expected.to eq nil
    end
  end

  context 'inside the editor (builder)' do
    let(:rendering_mode) { :editor }
    let(:controller) { double('Controller', site_preview_path: '/maglev/preview') }
    it 'returns the preview path' do
      is_expected.to eq '/maglev/preview'
    end
  end
end
