# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Theme do
  describe '#section_categories' do
    let(:theme) { Maglev.theme }
    subject { theme.section_categories }
    it 'lists all the categories' do
      expect(subject.count).to eq 3
      expect(subject[0].id).to eq 'headers'
      expect(subject[1].id).to eq 'features'
      expect(subject[2].id).to eq 'call_to_actions'
    end
  end

  describe '#sections' do
    let(:theme) { Maglev.theme }
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
    let(:theme) { Maglev.theme }
    subject { theme.as_json }
    it 'includes the sections' do
      expect(subject['sections']).to include(hash_including('id' => 'showcase'))
    end
  end
end
