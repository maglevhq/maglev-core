# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ClonePage do
  let(:site) { create(:site) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site) }
  subject { service.call(page: page) }

  context "the original page doesn't exist yet" do
    let(:page) { build(:page) }
    it 'returns nil' do
      expect { subject }.to change(Maglev::Page, :count).by(0)
      is_expected.to eq nil
    end
  end

  context 'existing page' do
    let!(:page) { create(:page, :with_navbar) }
    it 'creates another page with the same attributes' do
      expect { subject }.to change(Maglev::Page, :count).by(1)
      expect(subject.title).to eq 'Home COPY'
      expect(subject.path).not_to eq page.path
      expect(subject.sections.count).to eq 3
    end
  end
end
