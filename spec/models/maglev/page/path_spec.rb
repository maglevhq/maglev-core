# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  describe 'validation' do
    it "doesn't allow creating a page without a path" do
      create(:page) # create the index page
      page = described_class.new(title: 'Hello world')
      expect(page).to be_invalid
      expect(page.errors.full_messages).to eq(['Path can\'t be blank'])
    end

    it "doesn't allow creating a page with a blank path" do
      create(:page) # create the index page
      page = described_class.new(title: 'Hello world', path: '')
      expect(page).to be_invalid
      expect(page.errors.full_messages).to eq(['Path can\'t be blank'])
    end

    it "doesn't allow creating a page with a path which already exists" do
      create(:page) # create the index page
      page = described_class.new(title: 'Hello world', path: 'index')
      expect(page).to be_invalid
      expect(page.errors.full_messages).to eq(['Path has already been taken'])
    end

    it "doesn't allow creating a page with a path which is not a valid path" do
      page = described_class.new(title: 'Hello world', path: 'foo bar')
      expect(page).to be_invalid
      pp page.errors
      expect(page.errors.full_messages).to eq(['Path is not a valid path'])
    end
  end

  describe 'cleaning path' do
    subject { path.value }

    let(:path) { Maglev::PagePath.new(value: value) }

    before { path.valid? }

    context 'the path contains a leading slash' do
      let(:value) { '/foo' }

      it { is_expected.to eq 'foo' }
    end

    context 'the path contains a trailing slash' do
      let(:value) { 'foo/' }

      it { is_expected.to eq 'foo' }
    end

    context 'the path contains multiple slashes' do
      let(:value) { 'foo///bar/index' }

      it { is_expected.to eq 'foo/bar/index' }
    end
  end

  describe 'adding a second canonical path' do
    subject { page.paths.create!(canonical: true, value: 'canonical-wannabe') }

    let(:page) { create(:page) }

    it 'fails miserably' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'with multiple paths' do
    let!(:page) { create(:page, path: 'original') }
    let(:redirection) { described_class.by_path('original').first }

    before { page.update!(path: 'newer') }

    it 'spawn new paths' do
      expect(page.paths.count).to eq 2
    end

    it 'set the latest path as default' do
      expect(page.reload.path).to eq('newer')
    end

    # it 'have a canonical path' do
    #   expect(page.canonical_path).to eq('newer')
    # end

    it 'are reachable by their redirections' do
      expect(redirection).to eq(page)
    end

    context 'Giving multiple modifications of the paths' do
      it 'doesn\'t create multiple identical non canonical paths' do
        page.update!(path: 'original')
        page.update!(path: 'newer')
        page.update!(path: 'brand/new')
        expect(page.paths.count).to eq 3
      end
    end
  end

  describe 'Translating an existing page' do
    it 'just runs fine' do
      page = nil
      Maglev::I18n.available_locales = %i[fr en]
      # 1. page created in FR
      Maglev::I18n.with_locale(:fr) do
        page = create(:page, title: 'A notre sujet', path: 'a-notre-sujet')
      end
      # 2. page updated with the default content in EN
      Maglev::I18n.with_locale(:en) do
        page.reload.update(title: 'A notre sujet', path: 'a-notre-sujet')
      end
      # 3. page update with the final content (EN)
      Maglev::I18n.with_locale(:en) do
        page.reload.update(title: 'About us', path: 'about-us')
      end
      expect(described_class.by_path('about-us', :en).count).to eq 1
    end
  end

  describe '#default_path' do
    subject { page.default_path }

    let!(:page) { create(:page, path: 'about-us') }

    context 'Given the current locale is the default one' do
      it 'returns the path in the default locale' do
        expect(subject).to eq 'about-us'
      end
    end

    context 'Given the current locale is different from the default one' do
      it 'returns the path in the default locale' do
        Maglev::I18n.with_locale(:es) do
          expect(subject).to eq 'about-us'
        end
      end
    end
  end

  # rubocop:disable Style/StringHashKeys
  describe '#path_hash' do
    subject { page.path_hash }

    let!(:page) { create(:page, path: 'about-us') }

    context 'Given the page hasn\'t been translated in FR' do
      it 'returns the paths in the default locale only' do
        expect(subject).to eq({ 'en' => 'about-us' })
      end
    end

    context 'Given the page has been translated in FR' do
      before { Maglev::I18n.with_locale(:fr) { page.update!(title: 'A notre sujet', path: 'a-notre-sujet') } }

      it 'returns the paths in the default locale only' do
        expect(subject).to eq({ 'en' => 'about-us', 'fr' => 'a-notre-sujet' })
      end
    end
  end
  # rubocop:enable Style/StringHashKeys
end
