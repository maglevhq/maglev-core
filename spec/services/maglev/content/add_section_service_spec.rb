# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::AddSectionService do
  let(:site) { create(:site) }
  let(:page) { create(:page, sections: nil) }
  let(:store) { create(:sections_content_store, page: page) }
  let(:theme) { build(:theme) }
  let(:layout_id) { 'default' }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }  

  subject(:service_call) { service.call(store: store, site: site, section_type: section_type, position: position, layout_id: layout_id) }

  context 'Given a section type that does not exist' do
    let(:section_type) { 'not_existing' }
    let(:position) { -1 }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownSection)
    end
  end

  context 'Given a site scoped section' do
    let(:site_scoped_store) { create(:sections_content_store, :site_scoped, :empty) }
    let(:store) { create(:sections_content_store, :empty, handle: 'header') }
    let(:section_type) { 'navbar' }
    let(:position) { -1 }
    
    it 'adds the section to the store' do
      expect { subject }.to change { store.sections.count }.by(1)
    end

    it 'adds the section to the site scoped store' do
      expect { subject }.to change { site_scoped_store.reload.sections&.count || 0 }.by(1)
    end

    it 'sets the same section id for the site and the page' do
      site_scoped_store # force the creation of the site scoped store only for this test
      subject
      site_scoped_store.reload.prepare_sections(theme)
      store.reload.prepare_sections(theme)
      expect(site_scoped_store.sections.dig(0, 'id')).to eq store.sections.first['id']
    end

    context 'Given the site has already a section with the same type' do
      let!(:site_scoped_store) { create(:sections_content_store, :site_scoped, :with_navbar) }
      
      it 'adds the section to the site' do
        subject
        expect(site_scoped_store.sections.count).to eq 1
        expect(site_scoped_store.sections.dig(0, 'id')).to eq 'abc'
        expect(store.sections.dig(0, 'id')).to eq 'abc'
      end
    end

    context 'Given the store has been modified while adding the section' do
      let!(:store) { create(:sections_content_store, :empty, handle: 'header') }
      
      before { Maglev::SectionsContentStore.find(store.id).touch } # force a change and so a lock version change

      it 'raises an exception about the stale store' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end
    end
  end

  context 'Given a page scoped section' do
    let(:section_type) { 'featured_product' }
    before { service_call }
    subject { store.sections.map { |section| section['type'] } }

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
      context 'When insert_at is top' do
        let(:section_type) { 'navbar' }
        let(:position) { 2 }
        it { is_expected.to eq %w[navbar jumbotron showcase] }
      end

      context 'When insert_at is bottom' do
        let(:section_type) { 'footer' }
        let(:position) { 0 }

        it { is_expected.to eq %w[jumbotron showcase footer] }
      end
    end    
  end

  context 'Given the section has been previously deleted' do
    let(:section_type) { 'jumbotron' }
    let(:position) { -1 }
    
    before do
      # make the jumbotron a singleton
      theme.sections.find('jumbotron').singleton = true

      # mark the first section (jumbotron) as deleted
      store.sections_translations_will_change!
      store.sections[0]['deleted'] = true
      store.save! 
    end

    it 'returns the recovered section' do
      expect(subject['type']).to eq 'jumbotron'
    end

    it 'doesn\'t add another jumbotron section to the store' do
      expect { subject }.to change { store.sections.count }.by(0)
    end
  end
end
