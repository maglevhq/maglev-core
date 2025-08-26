# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SettingTypes::CollectionItem do
  let(:instance) { described_class.new }

  describe '#content_label' do
    subject { instance.content_label(value) }

    describe 'value is a hash without a label' do
      let(:value) { { id: '123' } }
      it { is_expected.to eq nil }
    end

    describe 'value is a hash with a label' do
      let(:value) { { id: '123', label: 'Hello world' } }
      it { is_expected.to eq 'Hello world' }
    end
  end
end
