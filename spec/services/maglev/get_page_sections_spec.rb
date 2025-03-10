# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageSections do
  subject { service.call(page: page, locale: :en) }

  let(:theme) { build(:theme, :basic_layouts) }
  let(:fetch_sections_content) { double('FetchSectionsContent', call: [[], 0]) }
  let(:service) do
    described_class.new(
      fetch_theme: double('FetchTheme', call: theme),
      fetch_sections_content: fetch_sections_content
    )
  end

  context 'the page is brand new' do
    let(:page) { build(:page) }

    it 'returns the layout groups empty' do
      expect(subject).to eq([
                              { id: 'header', sections: [], lock_version: 0 },
                              { id: 'main', sections: [], lock_version: 0 },
                              { id: 'footer', sections: [], lock_version: 0 }
                            ])
    end
  end

  context 'the page has sections in the main region + a header and a footer' do
    let(:page) { build(:page, id: 1) }
    let(:header_sections) { build(:sections_content_store, :header).sections }
    let(:main_sections) { build(:sections_content_store, page: page).sections }
    let(:footer_sections) { build(:sections_content_store, :footer).sections }

    before do
      allow(fetch_sections_content).to receive(:call).with(handle: 'header',
                                                           locale: :en).and_return([
                                                                                     header_sections, 0
                                                                                   ])
      allow(fetch_sections_content).to receive(:call).with(handle: 'main-1', locale: :en).and_return([main_sections, 0])
      allow(fetch_sections_content).to receive(:call).with(handle: 'footer',
                                                           locale: :en).and_return([
                                                                                     footer_sections, 0
                                                                                   ])
    end

    it 'returns the sections of the main region' do
      expect(subject[0][:sections].map { |section| section['type'] }).to eq(%w[navbar])
      expect(subject[1][:sections].map { |section| section['type'] }).to eq(%w[jumbotron showcase])
      expect(subject[2][:sections].size).to eq 0
    end
  end
end
