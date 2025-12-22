# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionScreenshotUrl do
  subject { service.call(section: section) }

  let(:request_protocol) { 'https://' }
  let(:controller) { double('ApplicationController', request: double('Request', protocol: request_protocol)) }
  let(:context) { Maglev::ServiceContext.new(controller: controller, rendering_mode: :editor) }
  let(:screenshot_path) { '/theme/jumbotron.png' }
  let(:fetch_section_screenshot_path) { instance_double('FetchSectionScreenshotPath', call: screenshot_path) }

  let(:service) { described_class.new(fetch_section_screenshot_path: fetch_section_screenshot_path, context: context) }
  let(:section) { instance_double('Section', id: 'jumbotron', screenshot_timestamp: 42) }

  it 'returns the url to the screenshot of the section' do
    expect(subject).to eq '/theme/jumbotron.png?42'
  end

  context 'when there is a Rails asset host set' do
    let(:asset_host) { 'https://assets.maglev.local' }

    before do
      allow(Rails.application.config).to receive(:asset_host).and_return(asset_host)
    end

    it 'uses the Rails asset host to build the url' do
      expect(subject).to eq 'https://assets.maglev.local/theme/jumbotron.png?42'
    end

    context 'the asset host doesn\'t have a scheme' do
      let(:asset_host) { 'assets.maglev.local' }

      it 'adds the scheme to the asset host' do
        expect(subject).to eq 'https://assets.maglev.local/theme/jumbotron.png?42'
      end
    end
  end
end
