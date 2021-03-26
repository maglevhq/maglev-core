# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Theme do
  describe 'validation' do
    let(:theme) { build(:theme) }
    subject { theme.valid? }
    it { is_expected.to eq true }

    context 'id is required' do
      let(:theme) { build(:theme, id: nil) }
      it { is_expected.to eq false }
    end

    context 'name is required' do
      let(:theme) { build(:theme, name: nil) }
      it { is_expected.to eq false }
    end
  end

  describe '#section_categories' do
    let(:theme) { Maglev::Theme.default }
    subject { theme.section_categories }
    it 'lists all the categories' do
      expect(subject.count).to eq 3
      expect(subject[0].id).to eq 'headers'
      expect(subject[1].id).to eq 'features'
      expect(subject[2].id).to eq 'call_to_actions'
    end
  end

  describe '#sections' do
    let(:theme) { Maglev::Theme.default }
    let(:section) { subject.find('showcase') }
    subject { theme.sections }
    it 'creates all the sections of a theme' do
      expect(subject.count).to eq 2
      expect(section.name).to eq 'Showcase'
      expect(section.settings.count).to eq 1
      expect(section.blocks.count).to eq 1
    end
  end

  describe '#as_json' do
    let(:theme) { Maglev::Theme.default }
    subject { theme.as_json }
    it 'includes the sections' do
      expect(subject['sections'].last['id']).to eq('showcase')
    end
  end
end
