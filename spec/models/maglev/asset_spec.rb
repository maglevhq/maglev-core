# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Maglev::Asset, type: :model do
  it 'has a valid factory' do
    expect(build(:asset)).to be_valid
  end

  describe 'Given we analyze the uploaded file' do
    let(:asset) { described_class.new }

    before do
      asset.file.attach(
        io: File.open(Rails.root.join('../fixtures/files/asset.jpg').to_s),
        filename: 'asset.jpg',
        content_type: 'image/jpeg'
      )
    end

    it 'sets the width and height of the image' do
      asset.save
      expect(asset.width).to eq 800
    end
  end

  describe '#to_param' do
    subject { build(:asset, id: 1, filename: 'Et voilà.jpg').to_param }

    it 'removes accents, dots from the filename' do
      expect(subject).to eq '1-et-voila.jpg'
    end
  end
end

# == Schema Information
#
# Table name: maglev_assets
#
#  id           :bigint           not null, primary key
#  byte_size    :integer
#  content_type :string
#  filename     :string
#  height       :integer
#  width        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
