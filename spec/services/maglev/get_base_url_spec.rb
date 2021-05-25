# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetBaseUrl do
  let!(:site) { create(:site) }  
  let(:service) { 
    described_class.new(
      fetch_site: double('FetchSite', call: build(:site)),
      controller: controller,
    ) 
  }
  subject { service.call }

  context 'not in preview mode' do
    let(:controller) { double('Controller', preview_mode?: false, site_preview_path: '/maglev/preview') }
    it 'returns nil' do
      is_expected.to eq nil
    end
  end

  context 'in preview mode' do
    let(:controller) { double('Controller', preview_mode?: true, site_preview_path: '/maglev/preview') }
    it 'returns the preview path' do
      is_expected.to eq '/maglev/preview'
    end
  end
end
