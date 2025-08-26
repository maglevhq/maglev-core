# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Content::SectionContent do
  let(:theme) { build(:theme) }
  let(:page) { build(:page) }
  let(:raw_section_content) { page.sections.first }
  let(:section_content) { described_class.build(theme: theme, raw_section_content: raw_section_content) }

  context '#label' do
    it 'takes the first text setting value' do
      expect(section_content.label).to eq 'Hello world'
    end
  end

  context '#type_name' do
    it 'returns the type name' do
      expect(section_content.type_name).to eq 'Jumbotron'
    end

    context 'i18n' do
      it 'returns the translated type name' do
        I18n.with_locale(:fr) do
          expect(section_content.type_name).to eq 'Jumbotron [FR]'
        end
      end
    end
  end
end
