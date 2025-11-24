# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  describe 'JSON translation fields initialization' do
    it 'initializes translation fields with empty hashes when nil' do
      # Create a page without setting translation fields (simulating MySQL behavior)
      page = described_class.new(title_translations: nil)
      expect(page.title).to eq nil
    end

    it 'preserves existing translation values when not nil' do
      existing_translations = { en: 'Test Title' }
      page = described_class.new(title_translations: existing_translations)

      expect(page.title_translations).to eq(existing_translations.stringify_keys)
    end
  end

  describe '#index?' do
    subject { page.index? }

    let(:page) { build(:page) }

    it { is_expected.to eq true }

    context 'the path is different from index' do
      let(:page) { build(:page, path: '404') }

      it { is_expected.to eq false }
    end
  end

  describe '#published?' do
    let(:page) { build(:page) }

    subject { page.published? }

    it { is_expected.to eq false }

    context 'the page has been published' do
      let(:page) { build(:page, published_at: Time.current) }

      it { is_expected.to eq true }
    end
  end

  describe '#need_to_be_published?' do
    let(:page) { build(:page) }

    subject { page.need_to_be_published? }

    context 'the page has never been published' do
      let(:page) { build(:page) }

      it { is_expected.to eq true }
    end

    context 'the page has been published' do
      let(:page) { build(:page, :published) }

      it { is_expected.to eq false }

      context 'the page has just been modified and not published yet' do
        before do
          page.save
          page.update(title: 'New title')
        end

        it { is_expected.to eq true }
      end
    end
  end

  describe '#prepare_sections' do
    let(:page) { build(:page) }
    let(:theme) { build(:theme) }

    before { page.prepare_sections(theme) }

    it 'assign an id to each section and block' do
      expect(page.sections.first['id']).not_to eq nil
      expect(page.sections.last['id']).not_to eq nil
      expect(page.sections.last['blocks'].first['id']).not_to eq nil
    end

    it 'casts the value of an image setting type' do
      expect(page.sections.last['blocks'].last['settings'].last.dig('value', 'url')).to eq '/assets/screenshot-01.png'
    end
  end

  describe '#reorder_sections' do
    let(:page) { build(:page) }
    let(:theme) { build(:theme) }
    let(:sections) { page.sections }
    let(:new_section_ids) { sections.reverse.map { |section| section['id'] } }

    subject { page.reorder_sections(new_section_ids, page.lock_version) }

    it 'reorders the sections' do
      subject
      expect(page.sections.map { |section| section['id'] }).to eq new_section_ids
    end
  end

  describe '#delete_section' do
    let(:page) { build(:page) }
    let(:theme) { build(:theme) }
    let(:sections) { page.sections }
    let(:section_id) { sections.first['id'] }

    subject { page.delete_section(section_id) }

    it 'deletes the section' do
      subject
      expect(page.sections.map { |section| section['id'] }).not_to include(section_id)
    end
  end

  describe 'scopes' do
    describe '.by_id_or_path' do
      let!(:page) { create(:page) }

      it 'returns the page from its id' do
        expect(described_class.by_id_or_path(page.id).count).to eq 1
      end

      it 'returns the page from its path' do
        expect(described_class.by_id_or_path('index').count).to eq 1
      end
    end
  end
end

# == Schema Information
#
# Table name: maglev_pages
#
#  id                            :bigint           not null, primary key
#  lock_version                  :integer
#  meta_description_translations :jsonb
#  og_description_translations   :jsonb
#  og_image_url_translations     :jsonb
#  og_title_translations         :jsonb
#  published_at                  :datetime
#  sections_translations         :jsonb
#  seo_title_translations        :jsonb
#  title_translations            :jsonb
#  visible                       :boolean          default(TRUE)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
