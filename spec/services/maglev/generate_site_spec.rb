# frozen_string_literal: true

require 'rails_helper'

describe Maglev::GenerateSite do
  let(:theme) { build(:theme, :predefined_pages) }
  let(:service) { described_class.new }
  subject { service.call(theme: theme) }

  it 'creates a new site' do
    expect do
      expect(subject.default_locale.label).to eq 'English'
    end.to change(Maglev::Site, :count).by(1)
                                       .and change(Maglev::Page, :count).by(2)
  end
end
