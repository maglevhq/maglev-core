# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::PagePath, type: :model do
  let(:page) { create(:page) }

  it 'has a unique value per locale' do
    expect(page.paths.create(canonical: false, value: page.path)).not_to be_valid
  end

  it 'has a unique canonical per page' do
    expect(page.paths.create(canonical: true, value: 'whatevs')).not_to be_valid
  end

  it 'allows non-canonical non-duplicated values' do
    expect(page.paths.create(canonical: false, value: 'whatevs')).to be_valid
  end

  describe 'with a different locale' do
    let!(:value) { Translatable.with_locale(Translatable.default_locale) { page.path } }
    it 'allows same canonical in different locale' do
      Translatable.with_locale('es') do
        expect(page.paths.create(canonical: true, value: value)).to be_valid
      end
    end
  end
end
