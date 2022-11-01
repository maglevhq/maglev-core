# frozen_string_literal: true

require 'rails_helper'

describe Maglev::ChangeSiteLocales do
  subject { service.call(site: site, locales: locales) }

  let(:site) { create(:site, locales: [{ label: 'English', prefix: 'en' }]) }
  let(:service) { described_class.new }
  let(:locales) { [] }

  describe 'no locales are passed to the service' do
    let(:locales) { [] }

    it "doesn't touch the locales of the site" do
      expect { expect(subject).to eq nil }.not_to(change { site.reload.locale_prefixes })
    end
  end

  describe 'we want to add a new locale' do
    let(:locales) { [build_locale('English', 'en'), build_locale('French', 'fr')] }

    it 'adds the new locale to the site' do
      expect { expect(subject).to eq true }.to change { site.reload.locale_prefixes }.to %i[en fr]
    end
  end

  describe 'we want to change the default locale' do
    let(:locales) { [build_locale('French', 'fr'), build_locale('English', 'en')] }

    describe 'the new default locale doesn\'t have translated pages' do
      before do
        Maglev::I18n.with_locale(:en) { create(:page) }
      end

      it 'raises an exception' do
        expect { subject }.to raise_error('The translations for the new default locale are incomplete')
      end
    end

    describe 'thew new default locale have all the required translated pages' do
      before do
        page = nil
        Maglev::I18n.with_locale(:en) { page = create(:page) }
        Maglev::I18n.with_locale(:fr) { page.reload.update(title: 'Accueil', path: 'index') }
      end

      it 'changes the locales' do
        expect { expect(subject).to eq true }.to change { site.reload.locale_prefixes }.to %i[fr en]
      end
    end
  end

  def build_locale(label, prefix)
    Maglev::Site::Locale.new(label: label, prefix: prefix)
  end
end
