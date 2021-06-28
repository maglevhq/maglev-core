# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistSectionScreenshot do
  before { FileUtils.rm_rf(Rails.root.join('public/theme')) }

  let(:theme) { build(:theme) }
  let(:path) { '/sometheme/jumbotron.png' }
  let(:fetch_screenshot_path) do
    instance_double('FetchScreenshotPath', call: path)
  end
  let(:service) do
    described_class.new(
      fetch_theme: instance_double('FetchTheme', call: theme),
      fetch_screenshot_path: fetch_screenshot_path
    )
  end
  subject { service.call(base64_image: base64_image, section_id: 'jumbotron') }

  context 'the base64 image is empty' do
    let(:base64_image) { nil }
    it 'returns nil' do
      is_expected.to eq false
    end
  end

  context 'the base64 image is present' do
    let(:base64_image) { 'data:image/png;base64,bodyofthepngfile' }
    it 'persists the PNG in the filesystem' do
      is_expected.to eq true
      expect(File.exist?(Rails.root.join('public/sometheme/jumbotron.png'))).to eq true
    end
  end
end
