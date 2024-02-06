# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: 'Product' do
    sequence(:name) { |n| "Product ##{n.to_s.rjust(2, '0')}" }
    sequence(:sku) { |n| "sku-#{n}" }
    price { 42.0 }
    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/files/asset.jpg', 'image/jpeg') }

    trait :without_thumbnail do
      thumbnail { nil }
    end

    trait :sold_out do
      sold_out { true }
    end
  end
end

# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  name       :string
#  price      :float
#  sku        :string
#  sold_out   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
