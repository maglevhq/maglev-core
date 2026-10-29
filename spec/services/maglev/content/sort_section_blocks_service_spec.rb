# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::SortSectionBlocksService do
  let(:theme) { build(:theme) }
  let(:site) { create(:site) }
  let!(:page) { create(:page, number_of_showcase_blocks: 4) }
  let(:store) { fetch_sections_store('main', page.id) }
  let(:section) { store.find_section_by_type('showcase') }
  let(:section_id) { section['id'] }
  let(:parent_id) { nil }
  let(:block_ids) do
    [
      section.dig('blocks', 3, 'id'),
      section.dig('blocks', 0, 'id'),
      section.dig('blocks', 2, 'id'),
      section.dig('blocks', 1, 'id')
    ]
  end
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }
  let(:lock_version) { nil }

  before { store.prepare_sections(theme) }

  subject do
    service.call(store: store, section_id: section_id, block_ids: block_ids, parent_id: parent_id,
                 lock_version: lock_version)
  end

  it 'sorts the blocks' do
    expect { subject }.to change {
      section['blocks'].map do |block|
        block['settings'].dig(0, 'value')
      end
    }.to ['My project #4', 'My first project', 'My project #3', 'My project #2']
  end

  context 'Given an existing page section with a version' do
    let(:lock_version) { 0 }

    # rubocop:disable Rails/SkipsModelValidations
    before { store.touch }
    # rubocop:enable Rails/SkipsModelValidations

    it 'raises an exception about the stale store' do
      expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
    end
  end

  describe 'When the blocks are sorted in the tree' do
    let!(:page) { create(:page, :with_navbar) }
    let(:site_scoped_store) { create(:sections_content_store, :site_scoped, :empty) }
    let(:store) { fetch_sections_store('header') }
    let(:section) { store.find_section_by_type('navbar') }
    let(:parent_id) { 'menu-item-1' }
    let(:block_ids) do
      [
        section.dig('blocks', 3, 'id'),
        section.dig('blocks', 2, 'id')
      ]
    end

    before do
      site_scoped_store.sections = [section]
      site_scoped_store.prepare_sections(theme)
      site_scoped_store.save!
    end

    it 'sorts the blocks' do
      expect { subject }.to change {
        site_scoped_store.reload.sections.dig(0, 'blocks').map do |block|
          block['settings'].dig(0, 'value')
        end
      }.to ['Home', 'About us', 'Our office', 'Our team']
    end

    context 'when the sorted siblings are interleaved with other blocks' do
      # blocks are appended to the flat list as the editor creates them, so the children
      # of a menu item are rarely stored right after it
      let!(:page) do
        create(:page, header_sections: [{
                 id: 'abc',
                 type: 'navbar',
                 settings: [{ id: :logo, value: 'logo.png' }],
                 blocks: [
                   menu_item('home', 'Home'),
                   menu_item('about', 'About us'),
                   menu_item('about-team', 'Our team', parent_id: 'about'),
                   menu_item('contact', 'Contact'),
                   menu_item('about-office', 'Our office', parent_id: 'about'),
                   menu_item('contact-email', 'Email', parent_id: 'contact'),
                   menu_item('contact-phone', 'Phone', parent_id: 'contact'),
                   menu_item('blog', 'Blog')
                 ]
               }])
      end

      def menu_item(id, label, parent_id: nil)
        {
          id: id,
          type: 'menu_item',
          parent_id: parent_id,
          settings: [{ id: :label, value: label }, { id: :link, value: '/' }]
        }.compact
      end

      def block_ids_in_store
        site_scoped_store.reload.sections.dig(0, 'blocks').map { |block| block['id'] }
      end

      context 'sorting the root blocks' do
        let(:parent_id) { nil }
        let(:block_ids) { %w[blog contact about home] }

        it 'only moves the root blocks and leaves the nested blocks where they are' do
          subject
          expect(block_ids_in_store).to eq(
            %w[blog contact about-team about about-office contact-email contact-phone home]
          )
        end
      end

      context 'sorting the children of a block' do
        let(:parent_id) { 'about' }
        let(:block_ids) { %w[about-office about-team] }

        it 'only moves the children and leaves the other blocks where they are' do
          subject
          expect(block_ids_in_store).to eq(
            %w[home about about-office contact about-team contact-email contact-phone blog]
          )
        end
      end
    end
  end
end
