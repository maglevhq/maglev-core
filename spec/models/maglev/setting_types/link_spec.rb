# frozen_string_literal: true

require 'rails_helper'

describe Maglev::SettingTypes::Link do
  let(:instance) { described_class.new }

  describe '#cast_value' do
    subject { instance.cast_value(value) }

    describe 'value is a string (an url)' do
      let(:value) { 'https://pro.maglev.dev' }
      it { is_expected.to eq({ link_type: 'url', href: 'https://pro.maglev.dev', text: 'Link' }) }
    end

    describe 'value is a hash' do
      # rubocop:disable Style/StringHashKeys
      let(:value) { { 'link_type' => 'url', 'href' => 'https://pro.maglev.dev', 'text' => 'Hello' } }
      # rubocop:enable Style/StringHashKeys

      it { is_expected.to eq({ link_type: 'url', href: 'https://pro.maglev.dev', text: 'Hello' }) }
    end

    describe 'value is nil (got reset by the UI)' do
      let(:value) { nil }
      it { is_expected.to eq(nil) }
    end
  end

  describe '#content_label' do
    subject { instance.content_label(value) }

    describe 'value is nil' do
      let(:value) { nil }
      it { is_expected.to eq nil }
    end

    describe 'value is a hash' do
      # rubocop:disable Style/StringHashKeys
      let(:value) { { 'text' => 'Hello' } }
      # rubocop:enable Style/StringHashKeys
      it { is_expected.to eq 'Hello' }
    end
  end
end
