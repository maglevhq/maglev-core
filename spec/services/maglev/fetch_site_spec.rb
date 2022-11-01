# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSite do
  subject { service.call }

  let!(:site) { create(:site) }
  let(:service) { described_class.new }

  it 'returns the first site' do
    expect(subject.name).to eq 'My awesome site'
  end

  it 'sets up the available locales' do
    subject
    expect(Maglev::I18n.available_locales).to eq(%i[en fr])
  end
end
