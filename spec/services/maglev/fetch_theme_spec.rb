# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchTheme do
  let(:service) { described_class.new }
  subject { service.call }

  it 'returns the local theme' do
    expect(subject.name).to eq 'My simple theme'
  end
end
