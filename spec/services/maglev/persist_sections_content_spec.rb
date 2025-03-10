# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PersistSectionsContent do
  subject { service.call(site: site, page: page, sections_content: sections_content) }

  let(:site) { create(:site) }
  let!(:page) { create(:page) }
  let(:fetch_theme) { double('FetchTheme', call: build(:theme, :basic_layouts)) }
  let(:service) { described_class.new(fetch_theme: fetch_theme) }

  let(:sections_content) do
    JSON.parse([
      {
        id: 'header',
        sections: attributes_for(:sections_content_store, :header)[:sections]
      },
      {
        id: 'main',
        sections: attributes_for(:sections_content_store)[:sections]
      },
      {
        id: 'footer',
        sections: []
      }
    ].to_json)
  end

  it 'persist the content in DB' do
    subject
    expect(section_types('header')).to eq(%w[navbar])
    expect(section_types("main-#{page.id}")).to eq(%w[jumbotron showcase])
    expect(section_types('footer')).to eq([])
  end

  context 'Given a store has been modified while persisting the content' do
    let!(:header_store) { create(:sections_content_store, :header) }

    let(:sections_content) do
      JSON.parse([
        {
          id: 'header',
          sections: attributes_for(:sections_content_store, :header)[:sections],
          lock_version: 1
        }
      ].to_json)
    end

    it 'raises an exception about the stale content' do
      expect { subject }.to raise_exception(ActiveRecord::StaleObjectError)
    end
  end

  def section_types(store_handle)
    Maglev::SectionsContentStore
      .find_by(handle: store_handle)
      .sections
      .map { |section| section['type'] }
  end
end
