# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionScreenshotUrl do
  subject { service.call(section: section) }

  let(:screenshot_path) { '/theme/jumbotron.png' }
  let(:fetch_section_screenshot_path) { instance_double('FetchSectionScreenshotPath', call: screenshot_path) }
  let(:service) { described_class.new(fetch_section_screenshot_path: fetch_section_screenshot_path) }
  let(:section) { instance_double('Section', id: 'jumbotron', screenshot_timestamp: 42) }

  it 'returns the url to the screenshot of the section' do
    expect(subject).to eq '/theme/jumbotron.png?42'
  end

  context 'when there is a Rails asset host set' do
    before do
      allow(Rails.application.config).to receive(:asset_host).and_return('https://assets.maglev.local')
    end

    it 'uses the Rails asset host to build the url' do
      expect(subject).to eq 'https://assets.maglev.local/theme/jumbotron.png?42'
    end
  end
end
