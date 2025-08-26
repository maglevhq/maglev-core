# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SettingTypes::Text do
  let(:instance) { described_class.new }

  describe '#content_label' do
    subject { instance.content_label(value) }

    describe 'value is a string' do
      let(:value) { 'Hello world' }
      it { is_expected.to eq 'Hello world' }
    end

    describe 'value is a string with html tags' do
      let(:value) { '<p>Hello world</p>' }
      it { is_expected.to eq 'Hello world' }
    end

    describe 'value is a string with html tags and br' do
      let(:value) { '<p>Hello world<br>Hello world</p>' }
      it { is_expected.to eq 'Hello world Hello world' }
    end

    describe 'value is a string with html tags and br' do
      let(:value) { '<p>Hello world<br>Hello world</p>' }
      it { is_expected.to eq 'Hello world Hello world' }
    end
  end
end
