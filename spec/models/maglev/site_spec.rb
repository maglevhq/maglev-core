# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Site, type: :model do
  it 'has a valid factory' do
    expect(build(:site)).to be_valid
  end

  describe 'validation' do
    subject { site.valid? }

    context 'no locales' do
      let(:site) { build(:site, locales: []) }

      it { is_expected.to eq false }
    end

    context 'one of the locales is invalid' do
      let(:site) { build(:site, locales: [{ prefix: 'English' }]) }

      it { is_expected.to eq false }
    end
  end

  describe '#default_locale' do
    subject { site.default_locale }

    let(:site) { build(:site) }

    it 'returns the first locale' do
      expect(subject.label).to eq 'English'
    end
  end

  describe '#locale_prefixes' do
    subject { site.locale_prefixes }

    let(:site) { build(:site) }

    it 'returns the list of the locale prefixes' do
      expect(subject).to eq(%i[en fr])
    end
  end

  describe '#style' do
    subject { site.style }

    let(:site) { build(:site, :with_style) }

    it 'lets the developer access to the theme style settings filled by the editor' do
      # rubocop:disable Style/StringHashKeys
      expect(subject).to include(
        a_hash_including('value' => '#ff00ff'),
        a_hash_including('value' => 'roboto')
      )
      # rubocop:enable Style/StringHashKeys
    end
  end
end

# == Schema Information
#
# Table name: maglev_sites
#
#  id                    :bigint           not null, primary key
#  domain                :string
#  handle                :string
#  locales               :jsonb
#  lock_version          :integer
#  name                  :string
#  navigation            :jsonb
#  sections_translations :jsonb
#  siteable_type         :string
#  style                 :jsonb
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  siteable_id           :bigint
#  theme_id              :string
#
# Indexes
#
#  index_maglev_sites_on_siteable  (siteable_type,siteable_id)
#
