# frozen_string_literal: true

FactoryBot.define do
  factory :asset, class: Maglev::Asset do
    file { Rack::Test::UploadedFile.new('spec/fixtures/files/asset.jpg', 'image/jpg') }
    filename { 'asset.jpg' }
    content_type { 'image/jpg' }
  end
end
