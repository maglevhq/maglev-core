# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  describe 'search' do
    before do
      create(:page, title: 'Chicago', path: 'bands/chicago')
      create(:page, title: 'Boston', path: 'bands/boston')
      create(:page, title: 'San Francisco', path: 'cities/sf')
    end

    subject { described_class.search(q, 'en') }

    describe 'Given we search from the title' do
      let(:q) { 'boston' }

      it { expect(subject.all.map(&:title).sort).to eq ['Boston'] }
    end

    describe 'Given we search from the path' do
      let(:q) { 'bands' }

      it { expect(subject.all.map(&:title).sort).to eq %w[Boston Chicago] }
    end
  end
end
