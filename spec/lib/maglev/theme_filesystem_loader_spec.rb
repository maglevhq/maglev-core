# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ThemeFilesystemLoader do
  describe '#call' do
    # rubocop:disable Lint/UnusedBlockArgument
    let(:fetch_section_screenshot_path) { ->(theme:, section:, absolute:) { path } }
    # rubocop:enable Lint/UnusedBlockArgument

    subject { described_class.new(fetch_section_screenshot_path).call(Pathname.new(path)) }

    context 'There are 2 sections with the same id in different categories' do
      let(:path) { File.expand_path('./spec/fixtures/themes/theme_with_sections_with_same_id') }

      it 'raises a DuplicateSectionDefinition error' do
        expect { subject }.to raise_error(Maglev::Errors::DuplicateSectionDefinition)
      end
    end
  end
end
