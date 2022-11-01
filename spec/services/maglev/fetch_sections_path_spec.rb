# frozen_string_literal: true

require 'rails_helper'

describe Maglev::FetchSectionsPath do
  subject { service.call }

  let(:service) { described_class.new }

  it 'returns the local theme' do
    expect(subject).to eq 'theme'
  end
end
