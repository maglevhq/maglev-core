# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistPage do
  subject { service.call(page: page, page_attributes: page_attributes, site: site, site_attributes: site_attributes) }

  let(:site) { create(:site) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme)) }
  let(:service) { described_class.new(fetch_theme: fetch_theme) }
  let(:site_attributes) { nil }

  context 'brand new page' do
    let(:page) { build(:page) }
    let(:page_attributes) { { title: 'Hello world' } }

    it 'persists the page in the DB' do
      expect { subject }.to change(Maglev::Page, :count).by(1)
      expect(page.title).to eq 'Hello world'
    end
  end

  context 'existing page' do
    let!(:page) { create(:page) }
    let(:page_attributes) { { title: 'Home page [UPDATED]' } }

    it 'persists the changes in the DB' do
      expect { subject }.to change(Maglev::Page, :count).by(0)
      expect(page.title).to eq 'Home page [UPDATED]'
    end
  end

  context 'Given the site attributes are not empty' do
    let(:page) { create(:page) }
    let(:page_attributes) { attributes_for(:page, :with_navbar) }
    let(:section) { attributes_for(:page, :with_navbar)[:sections][0].with_indifferent_access }
    let(:site_attributes) { { sections: [section] } }

    it 'copies the global content of a page to the site record' do
      subject
      expect(site.sections.size).to eq 1
      expect(site.find_section('navbar')).not_to eq nil
    end

    context 'Given the site has been modified while persisting the page' do
      before do
        another_site_instance = Maglev::Site.find(site.id)
        another_site_instance.update(attributes_for(:site, :with_navbar))
      end

      let(:site_attributes) { { sections: [section], lock_version: 0 } }

      it 'raises an exception about the stale site' do
        expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
      end
    end

    context 'Given a brand new page with no global sections' do
      let(:site) { create(:site, :with_footer) }

      it "doesn't erase the existing site sections" do
        subject
        expect(site.reload.sections.size).to eq 2
        expect(site.reload.find_section('navbar')).not_to eq nil
        expect(site.reload.find_section('footer')).not_to eq nil
      end
    end

    context 'Given the site has a new style' do
      let(:site_attributes) { { style: [{ id: 'font_size', value: '16px' }] } }

      it 'assigns the new style' do
        subject
        # rubocop:disable Style/StringHashKeys
        expect(site.style).to eq([{ 'id' => 'font_size', 'value' => '16px' }])
        # rubocop:enable Style/StringHashKeys
      end
    end
  end
end
