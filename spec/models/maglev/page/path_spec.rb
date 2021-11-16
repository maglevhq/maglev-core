# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  describe 'adding a second canonical path' do
    let(:page) { create(:page) }
    subject { page.paths.create!(canonical: true, value: 'canonical-wannabe') }

    it 'fails miserably' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'with multiple paths' do
    let!(:page) { create(:page, path: 'original') }
    let(:redirection) { Maglev::Page.by_path('original').first }
    before { page.update!(path: 'newer') }

    it 'spawn new paths' do
      expect(page.paths.count).to eq 2
    end

    it 'set the latest path as default' do
      expect(page.reload.path).to eq('newer')
    end

    it 'have a canonical path' do
      expect(page.canonical_path).to eq('newer')
    end

    it 'are reachable by their redirections' do
      expect(redirection).to eq(page)
    end
  end

  describe '#default_path' do
    let!(:page) { create(:page, path: 'about-us') }
    subject { page.default_path }
    context 'Given the current locale is the default one' do
      it 'returns the path in the default locale' do
        is_expected.to eq 'about-us'
      end
    end
    context 'Given the current locale is different from the default one' do
      it 'returns the path in the default locale' do
        Maglev::I18n.with_locale(:es) do
          is_expected.to eq 'about-us'
        end
      end
    end
  end

  # rubocop:disable Style/StringHashKeys
  describe '#path_hash' do
    let!(:page) { create(:page, path: 'about-us') }
    subject { page.path_hash }
    context 'Given the page hasn\'t been translated in FR' do
      it 'returns the paths in the default locale only' do
        is_expected.to eq({ 'en' => 'about-us' })
      end
    end
    context 'Given the page has been translated in FR' do
      before { Maglev::I18n.with_locale(:fr) { page.update!(title: 'A notre sujet', path: 'a-notre-sujet') } }
      it 'returns the paths in the default locale only' do
        is_expected.to eq({ 'en' => 'about-us', 'fr' => 'a-notre-sujet' })
      end
    end
  end
  # rubocop:enable Style/StringHashKeys
end
