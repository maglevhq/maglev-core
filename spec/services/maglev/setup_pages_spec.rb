# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SetupPages do
  subject { service.call(site: site, theme: theme) }

  let(:service) { described_class.new }
  let(:site) { build(:site) }

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

    it 'persist the content of the site scoped sections' do
      subject
      expect(site.reload.sections.size).to eq(1)
    end
  end
end
