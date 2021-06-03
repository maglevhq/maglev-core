# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  describe '#index?' do
    let(:page) { build(:page) }
    subject { page.index? }
    it { is_expected.to eq true }
    context 'the path is different from index' do
      let(:page) { build(:page, path: '404') }
      it { is_expected.to eq false }
    end
  end

  describe '#prepare_sections' do
    let(:page) { build(:page) }
    before { page.prepare_sections }
    it 'assign an id to each section and block' do
      expect(page.sections.first['id']).not_to eq nil
      expect(page.sections.last['id']).not_to eq nil
      expect(page.sections.last['blocks'].first['id']).not_to eq nil
    end
  end
end
