# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Content::SectionContent do
  let(:theme) { build(:theme) }
  let(:page) { build(:page) }
  let(:store) { build(:sections_content_store, page: page) }
  let(:raw_section_content) { store.sections.first }
  let(:section_content) { described_class.build(theme: theme, store_handle: 'main', raw_section_content: raw_section_content) }

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

  context '#blocks' do
    let(:store) { build(:sections_content_store, :with_navbar, page: page) }

    it 'builds all the blocks of the section' do
      expect(section_content.blocks.count).to eq 4
    end

    describe 'a block' do
      it 'returns the block type' do
        expect(section_content.blocks.first.type).to eq 'menu_item'
      end

      it 'returns the block settings' do
        expect(section_content.blocks.first.settings.count).to eq 2
      end

      it 'returns the block settings values' do
        expect(section_content.blocks.first.settings.first.value).to eq 'Home'
      end
    end
  end
end
