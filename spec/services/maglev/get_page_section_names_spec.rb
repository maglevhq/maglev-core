# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GetPageSectionNames do
  let(:theme) { build(:theme) }
  let(:service) { described_class.new(fetch_theme: double('FetchTheme', call: theme)) }
  let(:available_for_mirroring) { false }
  let(:already_mirrored_section_ids) { [] }

  subject do
    service.call(page: page, available_for_mirroring: available_for_mirroring,
                 already_mirrored_section_ids: already_mirrored_section_ids)
  end

  context 'the page has no sections (stores)' do
    let(:page) { build(:page) }

    it 'returns an empty array' do
      expect(subject).to eq([])
    end
  end

  context 'the page has a couple of sections (stores)' do
    let(:main_store) { fetch_sections_store('main', page.id) }
    let(:page) { create(:page) }

    it 'returns an array of hashes containing the id and name of a page section' do
      expect(subject).to match([
                                 a_hash_including(label: 'Jumbotron', layout_store_label: 'Main'),
                                 a_hash_including(label: 'Showcase', layout_store_label: 'Main')
                               ])
    end

    context 'when a section is deleted' do
      before do
        main_store.sections.first['deleted'] = true
        main_store.save!
      end

      it 'returns an array of hashes containing the id and name of a page section' do
        expect(subject).to match([a_hash_including(label: 'Showcase')])
      end
    end

    context 'when getting sections available for mirroring' do
      let(:available_for_mirroring) { true }

      context 'when a section is mirrored' do
        before do
          main_store.sections.first['mirror_of'] = { enabled: true }
          main_store.save!
        end

        it 'returns an array of hashes containing the id and name of a page section' do
          expect(subject).to match([a_hash_including(label: 'Showcase')])
        end
      end

      context 'when we already have the mirrored section' do
        let(:already_mirrored_section_ids) { ['def'] }

        it 'returns an array of hashes containing the id and name of a page section' do
          expect(subject).to match([a_hash_including(label: 'Showcase')])
        end
      end

      context 'when a section is site scoped' do
        before do
          theme.sections.find('jumbotron').site_scoped = true
        end

        it 'returns an array of hashes containing the id and name of a page section' do
          expect(subject).to match([a_hash_including(label: 'Showcase')])
        end
      end
    end
  end
end
