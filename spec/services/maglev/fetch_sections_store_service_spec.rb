# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionsStoreService do
  let(:theme) { build(:theme) }
  let(:site) { build(:site) }
  let(:page) { build(:page) }
  let(:handle) { 'header' }

  let(:service) { described_class.new }

  subject { service.call(page: page, handle: handle, theme: theme, site: site) }

  it 'creates the missing store in DB' do
    expect { subject }.to change(Maglev::SectionsContentStore, :count).by(1)
    expect(subject.handle).to eq('header')
  end

  context 'the store already exists' do
    before do
      create(:sections_content_store, handle: handle)
    end

    it 'returns the existing store' do
      expect { subject }.to change(Maglev::SectionsContentStore, :count).by(0)
      expect(subject.handle).to eq('header')
    end
  end
end
