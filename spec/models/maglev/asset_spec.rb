# frozen_string_literal: true

require 'rails_helper'

module Maglev
  RSpec.describe Asset, type: :model do
    it 'has a valid factory' do
      expect(build(:asset)).to be_valid
    end

    it 'requires an actual file' do
      expect(build(:asset, file: nil)).not_to be_valid
    end
  end
end
