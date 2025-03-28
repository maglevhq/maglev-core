# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SetupPages, type: :service do
  subject { service.call(site: site, theme: theme) }

  let(:service) { described_class.new }
  let(:site) { build(:site) }

  context 'the theme has no pre-defined pages' do
    let(:theme) { build(:theme, :basic_layouts) }

    it "doesn't create any page" do
      expect { subject }.to change(Maglev::Page, :count).by(0)
    end
  end

  context 'the theme has pre-defined pages' do
    let(:theme) { build(:theme, :basic_layouts, :predefined_pages) }

    it 'creates the pages in DB' do
      expect { subject }.to change(Maglev::Page, :count).by(3)
      expect(subject.map(&:title)).to eq ['Home', 'About us', 'Empty']
    end

    it 'creates the sections content stores' do
      expect { subject }.to change(Maglev::SectionsContentStore, :count).by(4)
      expect(section_types('header')).to eq ['navbar']
      expect(section_types('footer')).to eq []
      expect(section_types("main-#{Maglev::Page.home.first.id}")).to eq ['jumbotron', 'showcase']
    end
  end
end
