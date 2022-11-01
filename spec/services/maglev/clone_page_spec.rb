# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ClonePage do
  subject { service.call(page: page) }

  let(:site) { create(:site) }
  let(:fetch_site) { double('FetchSite', call: site) }
  let(:service) { described_class.new(fetch_site: fetch_site) }

  context "the original page doesn't exist yet" do
    let(:page) { build(:page) }

    it 'returns nil' do
      expect { subject }.to change(Maglev::Page, :count).by(0)
      expect(subject).to eq nil
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

    # rubocop:disable Style/StringHashKeys
    context 'multi-locales' do
      before { Maglev::I18n.with_locale(:fr) { page.update!(title: 'Accueil', path: 'index') } }

      it 'creates another page with the same attributes in all the locales' do
        expect(subject.title_translations).to eq({ 'en' => 'Home COPY', 'fr' => 'Accueil COPY' })
        expect(subject.path_hash.keys).to eq(%w[en fr])
        expect(subject.path_hash.values[0]).to match(/index-\w{4}/)
      end
    end
    # rubocop:enable Style/StringHashKeys
  end
end
