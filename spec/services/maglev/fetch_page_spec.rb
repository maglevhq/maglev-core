# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchPage do
  let!(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:locale) { :en }
  let(:default_locale) { :en }
  let(:service) { described_class.new }
  let(:fallback_to_default_locale) { false }
  subject do
    service.call(path: path, locale: locale, default_locale: default_locale,
                 fallback_to_default_locale: fallback_to_default_locale)
  end

  context 'the path is blank' do
    let(:path) { nil }
    it 'returns the index page' do
      expect(subject.title).to eq 'Home'
    end
  end

  context 'the path points to an existing page' do
    let!(:another_page) { create(:page, title: 'Hello world', path: 'hello-world') }
    let(:path) { 'hello-world' }
    it 'returns the correct page matching the path' do
      expect(subject.title).to eq 'Hello world'
    end
    context "the page hasn't been translated yet" do
      let(:locale) { :fr }
      it 'returns nil' do
        Maglev::Translatable.with_locale(:fr) do
          is_expected.to eq nil
        end
      end
      context 'the option fallback_to_default_locale has been enabled' do
        let(:fallback_to_default_locale) { true }
        it 'returns the page matching the path in the default locale' do
          expect(subject.title).to eq 'Hello world'
        end
      end
    end
  end

  context 'the path points to an unknown page' do
    let(:path) { 'unknown' }
    it 'returns nil' do
      is_expected.to eq nil
    end
  end
end
