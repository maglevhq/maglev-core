# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::PagePath, type: :model do
  let!(:page) { create(:page) }

  it "can't use a reserved path" do
    expect(page.paths.build(canonical: true, value: 'products', locale: 'fr')).to be_invalid
  end

  it "can't use a reserved path with a wildcard" do
    expect(page.paths.build(canonical: true, value: 'posts/hello-world', locale: 'fr')).to be_invalid
    expect(page.paths.build(canonical: true, value: 'posts/hello-world/bar', locale: 'fr')).to be_invalid
    expect(page.paths.build(canonical: true, value: 'posts', locale: 'fr')).to be_valid
  end

  it 'allows a path to be canonical in another locale' do
    expect(page.paths.build(canonical: true, value: page.path, locale: 'fr')).to be_valid
  end

  it 'allows a unique canonical path per page' do
    expect(page.paths.build(canonical: true, value: 'whatevs')).not_to be_valid
  end

  it 'allows non-canonical non-duplicated values' do
    expect(page.paths.build(canonical: false, value: 'whatevs')).to be_valid
  end

  describe 'with a different locale' do
    let!(:value) { Maglev::I18n.with_locale(Maglev::I18n.default_locale) { page.path } }

    it 'allows same canonical in different locale' do
      Maglev::I18n.with_locale('es') do
        expect(page.paths.build(canonical: true, value: value)).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: maglev_page_paths
#
#  id             :bigint           not null, primary key
#  canonical      :boolean          default(TRUE)
#  locale         :string           not null
#  value          :string           not null
#  maglev_page_id :bigint
#
# Indexes
#
#  canonical_speed                            (canonical,locale,value)
#  index_maglev_page_paths_on_maglev_page_id  (maglev_page_id)
#  scoped_canonical_speed                     (canonical,maglev_page_id,locale)
#
