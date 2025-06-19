# frozen_string_literal: true

require 'rails_helper'
require 'vite_rails'

describe Maglev::EditorHelper do
  let(:title) { nil }
  let(:primary_color) { '#040712' }
  let(:logo) { nil }
  let(:site) { build(:site) }
  let(:config) do
    Maglev::Config.new.tap do |config|
      config.title = title
      config.primary_color = primary_color
      config.logo = logo
    end
  end

  helper do
    include ::ViteRails::TagHelpers
    def maglev_config; end
    def maglev_site; end
  end

  before do
    allow(helper).to receive(:maglev_config).and_return(config)
    allow(helper).to receive(:maglev_site).and_return(site)
  end

  describe '#editor_window_title' do
    subject { helper.editor_window_title }

    it 'returns the default title' do
      expect(subject).to eq 'Maglev - EDITOR'
    end

    context 'the developer has set a custom title (String)' do
      let(:title) { 'My awesome CMS' }

      it 'returns the new title' do
        expect(subject).to eq 'My awesome CMS'
      end
    end

    context 'the developer has set a custom title (Proc)' do
      let(:title) { ->(site) { "#{site.name}!" } }

      it 'returns the new title' do
        expect(subject).to eq 'My awesome site!'
      end
    end
  end

  describe '#editor_primary_hex_color' do
    subject { helper.editor_primary_hex_color }

    it 'returns the primary color in a hexadecimal format' do
      expect(subject).to eq '#040712'
    end
  end

  describe '#editor_primary_rgb_color' do
    subject { helper.editor_primary_rgb_color }

    it 'returns the primary color in RGB (array)' do
      expect(subject).to eq [4, 7, 18]
    end

    context 'short version of the primary color' do
      let(:primary_color) { '#345' }

      it 'returns the primary color in RGB (array)' do
        expect(subject).to eq [51, 68, 85]
      end
    end
  end

  describe '#editor_logo_url' do
    subject { helper.editor_logo_url }

    it 'returns the default logo url' do
      expect(helper).to receive(:vite_asset_path).with('images/logo.svg')
      subject
    end

    context 'the developer has replaced the logo by a String' do
      let(:logo) { 'new-logo.png' }

      it 'returns the new logo' do
        expect(subject).to include '/assets/new-logo-'
      end
    end

    context 'the developer has replaced the logo by a Proc' do
      let(:logo) { ->(_site) { 'https://cdn.stuff.net/site-logo.png' } }

      it 'returns the new logo' do
        expect(subject).to eq 'https://cdn.stuff.net/site-logo.png'
      end
    end
  end
end
