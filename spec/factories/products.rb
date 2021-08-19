# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: Product do
    sequence(:name) { |n| "Product ##{n}" }
    sequence(:sku) { |n| "sku-#{n}" }
    price { 42.0 }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/files/asset.jpg', 'image/jpg') }
  end
end