# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSite do
  let!(:site) { create(:site) }
  let(:service) { described_class.new }
  subject { service.call }

  it 'returns the first site' do
    expect(subject.name).to eq 'My awesome site'
  end

  it 'sets up the available locales' do
    subject
    expect(Translatable.available_locales).to eq([:en, :fr]) 
  end
end
