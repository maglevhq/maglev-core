# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :thumbnail

  def thumbnail_url
    return nil unless thumbnail.attached?

    Rails.application.routes.url_helpers.cdn_image_url(
      thumbnail.variant(resize_to_limit: [200, 200])
    )
  end
end
