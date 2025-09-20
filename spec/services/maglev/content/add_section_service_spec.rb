# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::AddSectionService do
  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:theme) { build(:theme) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject(:service_call) { service.call(page: page, site: site, section_type: section_type, position: position) }

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

    it 'sets the same section id for the site and the page' do
      subject
      site.reload.prepare_sections(theme)
      page.reload.prepare_sections(theme)
      expect(site.sections.dig(0, 'id')).to eq page.sections.first['id']
    end

    context 'Given the site has already a section with the same type' do
      let(:site) { create(:site, :with_navbar) }

      it 'adds the section to the site' do
        subject
        expect(site.sections.count).to eq 1
        expect(site.sections.dig(0, 'id')).to eq 'abc'
        expect(page.sections.dig(0, 'id')).not_to eq 'abc'
      end
    end

    context 'Given the page has been modified while adding the section' do
      before { Maglev::Page.find(page.id).update!(title: 'UPDATED') } # force a change and so a lock version change

      it 'raises an exception about the stale page' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end
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

    context 'The definition of the section has a position overriding the position' do
      let(:section_type) { 'navbar' }
      let(:position) { 2 }
      it { is_expected.to eq %w[navbar jumbotron showcase] }
    end

    context 'The section is a singleton' do
      let(:page) { create(:page, :with_navbar) }
      let(:section_type) { 'navbar' }
      let(:position) { 2 }
      it 'prevents the section from being added more than once' do
        is_expected.to eq %w[navbar jumbotron showcase]
      end
    end
  end
end
