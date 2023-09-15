# frozen_string_literal: true

require 'rails_helper'

describe Maglev::AddSiteLocale do
  subject { service.call(site: site, locale: new_locale) }

  let(:site) { create(:site, :with_navbar, locales: [{ label: 'English', prefix: 'en' }]) }
  let(:service) { described_class.new }

  describe 'no new locale is passed to the service' do
    let(:new_locale) { nil }

    it "doesn't touch the locales of the site" do
      expect { expect(subject).to eq nil }.not_to(change { site.reload.locale_prefixes })
    end
  end

  describe 'we want to add a new locale' do
    let(:new_locale) { build_locale('French', 'fr') }
    let!(:page) { Maglev::I18n.with_locale(:en) { create(:page) } }

    it 'adds the new locale to the site' do
      expect { expect(subject).to eq true }.to change { site.reload.locale_prefixes }.to %i[en fr]
    end

    it 'sets a default content to all the pages in the new locale' do
      subject
      Maglev::I18n.with_locale(:fr) do
        expect(site.reload.sections).not_to eq nil
        page = Maglev::Page.first
        expect(page.title).to eq 'Home'
        expect(page.path).to eq 'index'
        expect(page.sections).not_to eq nil
      end
    end
  end

  def build_locale(label, prefix)
    Maglev::Site::Locale.new(label: label, prefix: prefix)
  end
end
