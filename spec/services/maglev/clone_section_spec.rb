# frozen_string_literal: true

require 'rails_helper'

describe Maglev::CloneSection do
  let(:theme) { build(:theme) }
  let(:page) { create(:page, sections: nil, layout_id: 'sidebar') }
  let(:store) { create(:sections_content_store, :with_navbar, page: page, handle: 'main') }
  let(:definition) { theme.sections.find('navbar') }
  let(:service) { described_class.new }

  subject(:copy) do
    service.call(store: store, section_id: 'abc', theme: theme, layout_id: page.layout_id)
  end

  before do
    definition.site_scoped = false
    definition.singleton = false
  end

  it 'inserts an independent copy with fresh section and nested block identities' do
    original = store.sections.first.deep_dup
    following = { id: 'following', type: 'showcase', settings: [], blocks: [] }.deep_stringify_keys
    store.sections << following
    store.save!
    published = create(:sections_content_store, :published, page: page, sections: store.sections.deep_dup)

    result = copy

    expect(store.reload.section_ids).to eq(['abc', result['id'], 'following'])
    expect(store.sections.first).to eq(original)
    expect(result['settings']).to eq(original['settings'])
    expect(result['blocks'].map { |block| block['id'] } & original['blocks'].map { |block| block['id'] }).to be_empty
    original['blocks'].zip(result['blocks']).each do |source_block, copied_block|
      expect(copied_block.except('id', 'parent_id')).to eq(source_block.except('id', 'parent_id'))
      next if source_block['parent_id'].blank?

      parent_index = original['blocks'].index { |block| block['id'] == source_block['parent_id'] }
      expect(copied_block['parent_id']).to eq(result['blocks'][parent_index]['id'])
    end
    expect(published.reload.sections).to eq([original, following])
  end

  it 'deep copies nested setting values and preserves independence after saving and reloading' do
    original = store.sections.first.deep_dup
    result = copy
    result['blocks'].last['settings'].last['value']['href'] = '/clone-only'

    expect(store.sections.first).to eq(original)
    store.sections_translations_will_change!
    store.save!
    copied_content = store.reload.sections.last.deep_dup
    store.sections.first['blocks'].last['settings'].last['value']['href'] = '/original-only'
    store.sections_translations_will_change!
    store.save!

    expect(store.reload.sections.last).to eq(copied_content)
  end

  it 'marks the page as having unpublished changes' do
    page.update!(updated_at: 1.day.ago)

    copy

    expect(page.reload.updated_at).to be > 1.hour.ago
  end

  it 'keeps deletion of either section independent' do
    cloned_id = copy['id']
    store.delete_section(cloned_id)
    store.save!
    expect(store.reload.find_section_by_id('abc')).to be_present

    cloned_id = service.call(store: store, section_id: 'abc', theme: theme, layout_id: page.layout_id)['id']
    store.delete_section('abc')
    store.save!
    expect(store.reload.find_section_by_id(cloned_id)).to be_present
  end

  it 'clones only the active locale' do
    english = store.sections.deep_dup
    french = english.deep_dup
    french.first['settings'].first['value'] = 'french-logo.png'
    store.update!(sections_translations: { en: english, fr: french })
    Maglev::I18n.available_locales = %i[en fr]

    Maglev::I18n.with_locale(:fr) { copy }

    translations = store.reload.sections_translations
    expect(translations['en']).to eq(english)
    expect(translations['fr'].size).to eq(2)
    expect(translations['fr'].last['settings']).to eq(french.first['settings'])
  end

  %i[site_scoped singleton].each do |restriction|
    it "rejects #{restriction} sections without changing the store" do
      definition.public_send("#{restriction}=", true)

      expect { copy }.to raise_error(described_class::NotCloneable)
      expect(store.reload.sections.size).to eq(1)
    end
  end

  context 'with a mirrored section' do
    let(:source_page) { create(:page, sections: nil, path: 'source', layout_id: 'sidebar') }
    let(:source_store) { create(:sections_content_store, :with_navbar, page: source_page, handle: 'main') }

    before do
      source_store.sections.first['settings'].first['value'] = 'current-source-logo.png'
      source_store.save!
      store.sections.first['mirror_of'] = {
        enabled: true, page_id: source_page.id, layout_store_id: 'main', section_id: 'abc'
      }.stringify_keys
      store.sections.first['lock_version'] = 7
      store.save!
    end

    it 'snapshots the current source and removes its mirroring and lock metadata' do
      result = copy

      expect(result).not_to have_key('mirror_of')
      expect(result).not_to have_key('lock_version')
      expect(result['settings']).to eq(source_store.sections.first['settings'])
      source_store.sections.first['settings'].first['value'] = 'later-source-logo.png'
      source_store.save!
      expect(store.reload.sections.last).to eq(result)
    end

    it 'rejects missing sources without changing content' do
      source_store.destroy!

      expect { copy }.to raise_error(ActiveRecord::RecordNotFound)
      expect(store.reload.sections.size).to eq(1)
    end

    it 'rejects circular mirrors without changing content' do
      source_store.sections.first['mirror_of'] = store.sections.first['mirror_of'].deep_dup
      source_store.save!

      expect { copy }.to raise_error(described_class::NotCloneable)
      expect(store.reload.sections.size).to eq(1)
    end
  end
end
