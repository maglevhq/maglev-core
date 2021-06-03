# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SetupPages do
  let(:service) { described_class.new }
  subject { service.call(theme: theme) }

  context 'the theme has no pre-defined pages' do
    let(:theme) { build(:theme) }
    it "doesn't create any page" do
      expect { subject }.to change(Maglev::Page, :count).by(0)
    end
  end

  context 'the theme has pre-defined pages' do
    let(:theme) { build(:theme, :predefined_pages) }
    it 'creates the pages in DB' do
      expect { subject }.to change(Maglev::Page, :count).by(2)
      expect(subject.pluck(:title)).to eq ['Home', 'About us']
    end
  end
end
