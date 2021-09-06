# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  describe 'translated attributes' do
    it 'behave like normal' do
      page = create(:page)
      page.title = 'Overriden title'
      expect(page.title).to eq('Overriden title')
      expect(page.title_translations).to eq({ en: 'Overriden title' }.stringify_keys)
      page.save!
      expect(page.reload.title).to eq('Overriden title')
    end

    it 'obey locale changes' do
      page = create(:page, title: 'Translated page')
      Translatable.with_locale(:es) do
        expect(page.title).to be_blank
        page.title = 'Mi página'
        page.path = 'mi-pagina'
        page.save!
        expect(page.reload.paths.count).to eq(2)
        expect(page.title).to eq('Mi página')
        expect(page.title_translations).to eq({
          en: 'Translated page',
          es: 'Mi página'
        }.stringify_keys)
      end
      expect(page.title).to eq('Translated page')
    end
  end

  describe '#index?' do
    let(:page) { build(:page) }
    subject { page.index? }
    it { is_expected.to eq true }
    context 'the path is different from index' do
      let(:page) { build(:page, path: '404') }
      it { is_expected.to eq false }
    end
  end

  describe '#prepare_sections' do
    let(:page) { build(:page) }
    before { page.prepare_sections }
    it 'assign an id to each section and block' do
      expect(page.sections.first['id']).not_to eq nil
      expect(page.sections.last['id']).not_to eq nil
      expect(page.sections.last['blocks'].first['id']).not_to eq nil
    end
  end

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
end
