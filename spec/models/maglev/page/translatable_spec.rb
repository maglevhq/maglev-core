# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Page, type: :model do
  describe 'translated attributes' do
    it 'behaves like normal' do
      page = create(:page)
      page.title = 'Overriden title'
      expect(page.title).to eq('Overriden title')
      expect(page.sections.map { |section| section['type'] }).to eq(%w[jumbotron showcase])
      expect(page.title_translations).to eq({ en: 'Overriden title' }.stringify_keys)
      page.save!
      expect(page.reload.title).to eq('Overriden title')
    end

    it 'obeys to locale changes' do
      page = create(:page, title: 'Translated page')
      Maglev::I18n.with_locale(:es) do
        expect(page.title).to be_blank
        expect(page.sections).to be_blank
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
end
