# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::I18n do
  it 'has a default locale' do
    expect(described_class.current_locale).to eq(:en)
  end

  describe 'with_locale' do
    it 'temporarily changes locale' do
      expect(described_class.current_locale).to eq(:en)
      described_class.with_locale(:es) do
        expect(described_class.current_locale).to eq(:es)
      end
      expect(described_class.current_locale).to eq(:en)
    end
  end

  it 'disallows setting an unavailable locale' do
    expect { described_class.current_locale = :fr }.to raise_error Maglev::I18n::UnavailableLocaleError
  end
end
