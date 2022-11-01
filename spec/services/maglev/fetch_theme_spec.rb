# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchTheme do
  subject { service.call }

  let(:service) { described_class.new }

  it 'returns the local theme' do
    expect(subject.name).to eq 'My simple theme'
  end
end
