# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::Image do
  let(:asset_host) { nil }
  let(:config) { instance_double('MaglevConfig', asset_host: asset_host) }
  let(:site) { instance_double('MaglevSite') }
  let(:section_component) { double('Maglev::SectionComponent', site: site, config: config) }
  let(:image) { described_class.new(section_component, content, setting) }

  context 'content is a string' do
    let(:content) { 'https://placeholder.net/random-image.png' }
    let(:setting) do
      double('Maglev::Section::Setting', default: 'https://placeholder.net/default-image.png',
                                         id: 'image', label: 'Image', type: 'image',
                                         options: {})
    end

    describe 'to_s method' do
      it { expect(image.to_s).to eq('https://placeholder.net/random-image.png') }
    end

    describe 'url method' do
      it { expect(image.url).to eq('https://placeholder.net/random-image.png') }
    end

    describe 'present? method' do
      it { expect(image.present?).to eq true }

      describe 'content is blank' do
        let(:content) { nil }
        it { expect(image.present?).to eq false }
      end
    end

    context 'using a asset_host' do
      context 'the asset_host is a string' do
        let(:asset_host) { 'https://assets.maglev.local' }

        it { expect(image.url).to eq('https://placeholder.net/random-image.png') }
      end
    end
  end

  context 'data provided by DB' do
    let(:content) do
      { url: '/maglev/assets/42-welcome.png', alt_text: 'Hello world', height: 640, width: 1024 }
    end
    let(:setting) do
      double('Maglev::Section::Setting', default: 'https://placeholder.net/default-image.png',
                                         id: 'image', label: 'Image', type: 'image',
                                         options: {})
    end

    describe 'url method' do
      it { expect(image.url).to eq('/maglev/assets/42-welcome.png') }
    end

    describe 'width method' do
      it { expect(image.width).to eq(1024) }
    end

    describe 'height method' do
      it { expect(image.height).to eq(640) }
    end

    context 'using a asset_host' do
      context 'the asset_host is a string' do
        let(:asset_host) { 'https://assets.maglev.local' }

        it { expect(image.url).to eq('https://assets.maglev.local/maglev/assets/42-welcome.png') }

        context 'the image is from the public folder of the application' do
          let(:content) do
            { url: '/themes/placeholder.png', alt_text: 'Hello world' }
          end

          it { expect(image.url).to eq('https://assets.maglev.local/themes/placeholder.png') }
        end
      end

      context 'the asset_host is a Proc' do
        let(:asset_host) { ->(_site) { 'https://maglev.local' } }

        it { expect(image.url).to eq('https://maglev.local/maglev/assets/42-welcome.png') }
      end
    end
  end
end
