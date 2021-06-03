# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Site, type: :model do
  it 'has a valid factory' do
    expect(build(:site)).to be_valid
  end
end
