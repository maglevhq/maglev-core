# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistSectionScreenshot do
  subject { service.call(base64_image: base64_image, section_id: 'jumbotron') }

  before { FileUtils.rm_rf(Rails.root.join('public/theme')) }

  let(:theme) { build(:theme) }
  let(:path) { Rails.root.join('public/theme/jumbotron.jpg') }
  let(:fetch_section_screenshot_path) do
    instance_double('FetchSectionScreenshotPath', call: path)
  end
  let(:service) do
    described_class.new(
      fetch_theme: instance_double('FetchTheme', call: theme),
      fetch_section_screenshot_path: fetch_section_screenshot_path
    )
  end

  context 'the base64 image is empty' do
    let(:base64_image) { nil }

    it 'returns nil' do
      expect(subject).to eq false
    end
  end

  context 'the base64 image is present' do
    let(:base64_image) { "data:image/png;base64,#{raw_base64_logo}" }

    it 'persists the PNG in the filesystem' do
      expect(subject).to eq true
      expect(File.exist?(Rails.root.join('public/theme/jumbotron.jpg'))).to eq true
    end
  end

  def raw_base64_logo
    content = File.read(
      Rails.root.join('../fixtures/files/logo.png').to_s
    )
    Base64.encode64(content)
  end
end
