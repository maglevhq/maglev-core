# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchPage do
  let!(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:service) { described_class.new }
  subject { service.call(params: params) }

  context 'the path is blank' do
    let(:params) { {} }
    it 'returns the index page' do
      expect(subject.title).to eq 'Home'
    end
  end

  context 'the path points to an existing page' do
    let!(:another_page) { create(:page, title: 'Hello world', path: 'hello-world') }
    let(:params) { { path: 'hello-world' } }
    it 'returns the correct page matching the path' do
      expect(subject.title).to eq 'Hello world'
    end
  end

  context 'the path points to an unknown page' do
    let(:params) { { path: 'unknown' } }
    it 'returns nil' do
      is_expected.to eq nil
    end
  end
end
