# frozen_string_literal: true

require 'rails_helper'

describe Maglev::Content::DeleteSectionService do
  let(:site) { create(:site, :with_navbar) }
  let(:page) { create(:page) }
  let(:theme) { build(:theme) }
  let(:fetch_theme) { double('FetchTheme', call: theme) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site, fetch_theme: fetch_theme) }

  subject { service.call(page: page, section_id: section_id) }

  context 'Given an existing page section' do
    let(:section_id) { page.sections.first['id'] }

    it 'deletes the section' do
      expect(subject).to eq(true)
      expect(page.reload.section_ids).not_to include(section_id)
    end
  end

  context 'Given a site scoped section' do
    let(:section_id) { site.sections.first['id'] }

    before do
      page.sections.push(site.sections.first)
      page.sections_translations_will_change!
      page.save!
    end

    it 'deletes the section' do
      expect(subject).to eq(true)
      expect(site.reload.section_ids).not_to include(section_id)
      expect(page.reload.section_ids).not_to include(section_id)
    end
  end

  context 'Given a section that does not exist' do
    let(:section_id) { 'not_existing' }

    it 'raises an error' do
      expect { subject }.to raise_error(Maglev::Errors::UnknownSection)
    end
  end
end
