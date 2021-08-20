# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translatable do
  it 'has a default locale' do
    expect(Translatable.current_locale).to eq(:en)
  end

  describe 'with_locale' do
    it 'temporarily changes locale' do
      expect(Translatable.current_locale).to eq(:en)
      Translatable.with_locale(:es) do
        expect(Translatable.current_locale).to eq(:es)
      end
      expect(Translatable.current_locale).to eq(:en)
    end
  end
end
