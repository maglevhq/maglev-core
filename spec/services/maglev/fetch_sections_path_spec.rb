# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionsPath do
  let(:service) { described_class.new }
  subject { service.call }

  it 'returns the local theme' do
    expect(subject).to eq 'theme'
  end
end
