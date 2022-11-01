# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Asset, type: :model do
  it 'has a valid factory' do
    expect(build(:asset)).to be_valid
  end

  describe '#to_param' do
    subject { build(:asset, id: 1, filename: 'Et voilà.jpg').to_param }

    it 'removes accents, dots from the filename' do
      expect(subject).to eq '1-et-voila.jpg'
    end
  end
end
