# frozen_string_literal: true

# == Schema Information
#
# Table name: maglev_sections_content_stores
#
#  id                    :integer          not null, primary key
#  container_type        :string
#  handle                :string           default("WIP"), not null
#  lock_version          :integer
#  published             :boolean          default(FALSE)
#  sections_translations :json
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  container_id          :string
#  maglev_page_id        :integer
#
# Indexes
#
#  index_maglev_sections_content_stores_on_handle          (handle)
#  index_maglev_sections_content_stores_on_maglev_page_id  (maglev_page_id)
#  maglev_sections_content_stores_container_and_published  (container_id,container_type,published) UNIQUE
#  maglev_sections_content_stores_handle_and_page_id       (handle,maglev_page_id,published) UNIQUE
#
# Foreign Keys
#
#  maglev_page_id  (maglev_page_id => maglev_pages.id)
#
require 'rails_helper'

RSpec.describe Maglev::SectionsContentStore, type: :model do
  it 'has a valid factory' do
    expect(build(:sections_content_store)).to be_valid
  end

  describe '#prepare_sections' do
    let(:store) { build(:sections_content_store) }
    let(:theme) { build(:theme) }

    before { store.prepare_sections(theme) }

    it 'assign an id to each section and block' do
      expect(store.sections.first['id']).not_to eq nil
      expect(store.sections.last['id']).not_to eq nil
      expect(store.sections.last['blocks'].first['id']).not_to eq nil
    end

    it 'casts the value of an image setting type' do
      expect(store.sections.last['blocks'].last['settings'].last.dig('value', 'url')).to eq '/assets/screenshot-03.png'
    end
  end

  describe '#reorder_sections' do
    let(:store) { build(:sections_content_store) }
    let(:theme) { build(:theme) }
    let(:sections) { store.sections }
    let(:new_section_ids) { sections.reverse.map { |section| section['id'] } }

    subject { store.reorder_sections(new_section_ids) }

    it 'reorders the sections' do
      subject
      expect(store.sections.map { |section| section['id'] }).to eq new_section_ids
    end
  end

  describe '#delete_section' do
    let(:store) { build(:sections_content_store) }
    let(:theme) { build(:theme) }
    let(:sections) { store.sections }
    let(:section_id) { sections.first['id'] }

    subject { store.delete_section(section_id) }

    it 'deletes the section' do
      subject
      expect(store.sections.map { |section| section['id'] }).not_to include(section_id)
    end
  end
end
