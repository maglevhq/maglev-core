# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SetupPages, type: :service do
  let(:service) { described_class.new }
  let(:site) { build(:site) }

  subject { service.call(site: site, theme: theme) }

  context 'the theme has no pre-defined pages' do
    let(:theme) { build(:theme) }

    it "doesn't create any page" do
      expect { subject }.to change(Maglev::Page, :count).by(0)
    end
  end

  context 'the theme has pre-defined pages' do
    let(:theme) { build(:theme, :predefined_pages) }

    it 'creates the pages in DB' do
      expect { subject }.to change(Maglev::Page, :count).by(3)
      expect(subject.map(&:title)).to eq ['Home', 'About us', 'Empty']
    end

    it 'creates the sections content stores' do
      expect { subject }.to change(Maglev::SectionsContentStore, :count).by(5)
      expect(section_types('header')).to eq ['navbar']
      expect(section_types('footer')).to eq []
      expect(section_types('main', Maglev::Page.home.first.id)).to eq %w[jumbotron showcase]
    end
  end

  context 'the theme has custom store handles' do
    let(:theme) { build(:theme, :layout_with_custom_handle, :predefined_pages) }

    it 'creates the sections content stores' do
      expect { subject }.to change(Maglev::SectionsContentStore, :count).by(5)
      expect(fetch_sections_store('header')).to eq nil
      expect(section_types('global_header')).to eq ['navbar']
      expect(section_types('main', Maglev::Page.home.first.id)).to eq %w[jumbotron showcase]
    end
  end
end
