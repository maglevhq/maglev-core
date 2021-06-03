# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageSectionNames do
  let(:theme) { build(:theme) }
  let(:service) { described_class.new(fetch_theme: double('FetchTheme', call: theme)) }
  subject { service.call(page: page) }

  context 'the page has no sections' do
    let(:page) { build(:page, sections: []) }
    it 'returns an empty array' do
      is_expected.to eq([])
    end
  end

  context 'the page has a couple of sections' do
    let(:page) { build(:page).tap(&:prepare_sections) }
    it 'returns an array of hashes containing the id and name of a page section' do
      is_expected.to match([a_hash_including(name: 'Jumbotron'), a_hash_including(name: 'Showcase')])
    end
  end
end
