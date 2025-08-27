# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::AddSectionService do
  subject(:service_call) { service.call(page: page, site: site, section_type: section_type, position: position) }

  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  context 'Given a section type that does not exist' do
    let(:section_type) { 'not_existing' }
    let(:position) { -1 }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownSection)
    end
  end

  context 'Given a site scoped section' do
    let(:section_type) { 'navbar' }
    let(:position) { -1 }

    it 'adds the section to the site' do
      expect { subject }.to change { site.sections&.count || 0 }.by(1)
    end

    it 'adds the section to the page' do
      expect { subject }.to change { page.sections.count }.by(1)
    end
  end

  context 'Given a page scoped section' do
    let(:section_type) { 'featured_product' }
    before { service_call }
    subject { page.sections.map { |section| section['type'] } }

    context 'When the position is -1, the section is added at the end' do
      let(:position) { -1 }
      it { is_expected.to eq %w[jumbotron showcase featured_product] }
    end

    context 'When the position is 0, the section is added at the top' do
      let(:position) { 0 }
      it { is_expected.to eq %w[featured_product jumbotron showcase] }
    end

    context 'When the position is 1, the section is added at the second position' do
      let(:position) { 1 }
      it { is_expected.to eq %w[jumbotron featured_product showcase] }
    end
  end
end
