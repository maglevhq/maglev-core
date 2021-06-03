# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageFullpath do
  let(:site) { create(:site) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:get_base_url) { double('GetBaseUrl', call: '/maglev/preview') }
  let(:service) { described_class.new(fetch_site: fetch_site, get_base_url: get_base_url) }
  subject { service.call(page: page) }

  context "the page doesn't exist yet" do
    let(:page) { 42 }
    it 'returns nil' do
      is_expected.to eq nil
    end
  end

  context 'we pass the id of an existing page' do
    let(:page) { create(:page, path: 'hello-world').id }
    it 'returns the fullpath to the page' do
      is_expected.to eq '/maglev/preview/hello-world'
    end
  end

  context 'we pass the existing page itself' do
    subject { service.call(page: build(:page, path: 'hello-world')) }
    it 'returns the fullpath to the page' do
      is_expected.to eq '/maglev/preview/hello-world'
    end
  end
end
