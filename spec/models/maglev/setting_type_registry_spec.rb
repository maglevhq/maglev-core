# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::SettingTypeRegistry do
  describe '#types' do
    it 'includes core types' do
      expect(described_class.types).to eq %i[text image checkbox link color select collection_item icon divider hint]
    end
  end

  describe '#[]' do
    let(:type) { 'text' }

    subject { described_class[type] }

    it 'returns the instance of the setting' do
      expect(subject.class).to eq Maglev::SettingTypes::Text
    end

    context 'the type doesn\'t exist' do
      let(:type) { 'foo' }

      it 'raises an error' do
        expect { subject }.to raise_error(Maglev::UnknownSettingTypeError)
      end
    end
  end
end
