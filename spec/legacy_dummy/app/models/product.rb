# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail

  def thumbnail_url
    return nil unless thumbnail.attached?

    Rails.application.routes.url_helpers.cdn_image_url(
      thumbnail.variant(resize_to_limit: [200, 200])
    )
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def self.maglev_fetch_sold_out(site:, keyword:, max_items: 10)
    all
      .where(sold_out: true)
      .where(keyword.present? ? Product.arel_table[:name].matches("%#{keyword}%") : nil)
      .limit(max_items)
      .order(:name)
  end
  # rubocop:enable Lint/UnusedMethodArgument
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
