# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::Checkbox do
  let(:section_component) { double('Maglev::SectionComponent') }
  let(:content) { true }
  let(:setting) do
    double('Maglev::Section::Checkbox', default: false, id: 'display_title', label: 'Display title?', type: 'checkbox',
                                        options: {})
  end
  let(:checkbox) { described_class.new(section_component, content, setting) }

  describe 'to_s method' do
    it { expect(checkbox.to_s).to eq(true) }
  end

  describe 'Given the content is the "true" string' do
    let(:content) { 'true' }
    it { expect(checkbox.true?).to eq(true) }
  end

  describe 'Given the content is the "false" string' do
    let(:content) { 'false' }
    it { expect(checkbox.true?).to eq(false) }
  end
end
