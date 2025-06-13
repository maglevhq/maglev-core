# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageSectionNames do
  subject { service.call(page: page) }

  let(:theme) { build(:theme) }
  let(:service) { described_class.new(fetch_theme: double('FetchTheme', call: theme)) }

  context 'the page has no sections (stores)' do
    let(:page) { build(:page) }

    it 'returns an empty array' do
      expect(subject).to eq([])
    end
  end

  context 'the page has a couple of sections (stores)' do
    let(:page) { create(:page) }
    let(:handle) { "main-#{page.id}" }

    it 'returns an array of hashes containing the id and name of a page section' do
      expect(subject).to match([
                                 a_hash_including(name: 'Jumbotron'),
                                 a_hash_including(name: 'Showcase')
                               ])
    end
  end
end
