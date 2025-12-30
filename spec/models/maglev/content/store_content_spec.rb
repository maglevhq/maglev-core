# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Content::StoreContent do  
  let(:theme) { build(:theme) }
  let(:page) { build(:page) }
  let(:main_sections) { build(:sections_content_store, page: page).sections }
  let(:store) { { id: 'main', sections: main_sections, lock_version: 0 } }
  let(:instance) { described_class.build(store: store, theme: theme, layout_id: page.layout_id) }

  describe '#label' do
    subject { instance.label }

    it { is_expected.to eq 'Main' }
  end

  describe '#addable_sections' do
    subject { instance.addable_sections }

    it 'returns the available sections to add' do
      expect(subject.map(&:id).sort).to eq ['featured_product', 'jumbotron', 'showcase']
    end

    context 'when the store already has a singleton section of the same type' do
      before { theme.sections.find('jumbotron').singleton = true }

      it 'returns the available sections to add' do
        expect(subject.map(&:id).sort).to eq ['featured_product', 'showcase']
      end
    end

    context 'when the store already has a site scoped section of the same type' do
      before { theme.sections.find('jumbotron').site_scoped = true }

      it 'returns the available sections to add' do
        expect(subject.map(&:id).sort).to eq ['featured_product', 'showcase']
      end
    end

    context 'when the store already has a recoverable section of the same type' do
      before { theme.find_layout('default').find_group('main').recoverable = ['jumbotron'] }

      it 'returns the available sections to add' do
        expect(subject.map(&:id).sort).to eq ['featured_product', 'showcase']
      end
    end
  end
end