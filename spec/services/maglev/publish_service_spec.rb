# frozen_string_literal: true

require 'rails_helper'

describe Maglev::PublishService do
  let(:service) { described_class.new }
  let(:site) { create(:site, :with_navbar) }
  let(:page) { create(:page) }

  subject { service.call(site: site, page: page) }

  context 'the page has never been published' do
    it 'creates 2 new sections content stores' do
      expect { subject }.to change { Maglev::SectionsContentStore.published.count }.by(2)
      expect(site.sections_content_stores.published.count).to eq 1
      expect(page.sections_content_stores.published.count).to eq 1
    end
  end

  context 'the page has already been published' do
    before do
      service.call(site: site, page: page)
    end

    it 'does not create new sections content stores' do
      expect { subject }.to change { Maglev::SectionsContentStore.published.count }.by(0)
    end
  end
end
