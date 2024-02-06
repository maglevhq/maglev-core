# frozen_string_literal: true

FactoryBot.define do
  factory :asset, class: 'Maglev::Asset' do
    file { Rack::Test::UploadedFile.new('spec/fixtures/files/asset.jpg', 'image/jpeg') }
    filename { 'asset.jpg' }
    content_type { 'image/jpeg' }
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
