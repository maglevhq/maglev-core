# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchScreenshotUrl do
  let(:screenshot_path) { '/theme/jumbotron.png' }
  let(:fetch_screenshot_path) { instance_double('FetchScreenshotPath', call: screenshot_path) }
  let(:service) { described_class.new(fetch_screenshot_path: fetch_screenshot_path) }
  let(:section) { instance_double('Section', id: 'jumbotron', screenshot_timestamp: 42) }
  subject { service.call(section: section) }

  it 'returns the url to the screenshot of the section' do
    expect(subject).to eq '/theme/jumbotron.png?42'
  end
end
