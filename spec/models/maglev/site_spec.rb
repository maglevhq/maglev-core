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
    let(:site) { build(:site) }
    subject { site.default_locale }
    it 'returns the first locale' do
      expect(subject.label).to eq 'English'
    end
  end

  describe '#locale_prefixes' do
    let(:site) { build(:site) }
    subject { site.locale_prefixes }
    it 'returns the list of the locale prefixes' do
      is_expected.to eq(%i[en fr])
    end
  end

  describe '#style' do
    let(:site) { build(:site, :with_style) }
    subject { site.style }
    it 'lets the developer access to the theme style settings filled by the editor' do
      # rubocop:disable Style/StringHashKeys
      is_expected.to include(
        a_hash_including('value' => '#ff00ff'),
        a_hash_including('value' => 'roboto')
      )
      # rubocop:enable Style/StringHashKeys
    end
  end
end
