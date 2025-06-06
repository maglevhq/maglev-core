# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  it 'has a valid factory' do
    expect(build(:page)).to be_valid
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
#  sections_translations         :jsonb
#  seo_title_translations        :jsonb
#  title_translations            :jsonb
#  visible                       :boolean          default(TRUE)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
