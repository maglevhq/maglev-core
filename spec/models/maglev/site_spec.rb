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
      let(:site) { build(:site, locales: [{ prefix: 'English'}]) }
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
      is_expected.to eq([:en, :fr])
    end
  end

  # describe '#add_locale' do
  #   let(:site) { build(:site) }
  #   it 'doesn\'t a new locale if the target is blank' do
  #     site.add_locale('French', '')
  #     expect(site.locales).to eq([{ 'label': 'English', 'prefix' => 'en' }])
  #   end
  #   it 'adds a new locale to the site' do
  #     site.add_locale('French', 'fr')
  #     expect(site.locales).to eq([{ 'label': 'English', 'prefix' => 'en' }, { 'label' => 'French', 'prefix' => 'fr' }])
  #   end
  #   it 'doesn\'t a new locale if another one with the same prefix exists' do
  #     site.add_locale('French', 'fr')
  #     site.add_locale('French #2', 'fr')
  #     expect(site.locales).to eq([{ 'label': 'English', 'prefix' => 'en' }, { 'label' => 'French', 'prefix' => 'fr' }])
  #   end
  # end

  # describe '#remove_locale' do
  #   let(:site) { build(:site, :french) }
  #   it 'removes a locale from the site locales' do
  #     expect(site.locales.size).to eq 2
  #     site.remove_locale('fr')
  #     expect(site.locales).to eq([{ 'label': 'English', 'prefix' => 'en' }])
  #   end
  #   it 'doesn\'t remove the locale if it\'s the last one' do

  #   end
  # end
end
