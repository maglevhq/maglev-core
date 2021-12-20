# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistPage do
  let(:site) { create(:site) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:service) { described_class.new(fetch_theme: fetch_theme) }
  subject { service.call(page: page, attributes: attributes, site: site) }

  context 'brand new page' do
    let(:page) { build(:page) }
    let(:attributes) { { title: 'Hello world' } }

    it 'persists the page in the DB' do
      expect { subject }.to change(Maglev::Page, :count).by(1)
      expect(page.title).to eq 'Hello world'
    end
  end

  context 'existing page' do
    let!(:page) { create(:page) }
    let(:attributes) { { title: 'Home page [UPDATED]' } }

    it 'persists the changes in the DB' do
      expect { subject }.to change(Maglev::Page, :count).by(0)
      expect(page.title).to eq 'Home page [UPDATED]'
    end
  end

  context 'the attributes includes content for a site scoped section' do
    let(:page) { create(:page) }
    let(:attributes) { attributes_for(:page, :with_navbar) }

    it 'copies the global content of a page to the site record' do
      subject
      expect(site.sections.size).to eq 1
      expect(site.find_section('navbar')).not_to eq nil
    end

    describe 'Given the site has been modified while persisting the page' do      
      before do
        another_site_instance = Maglev::Site.find(site.id)
        another_site_instance.update(attributes_for(:site, :with_navbar))
      end
      it 'raises an exception about the stale site' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end      
    end
  end
end
