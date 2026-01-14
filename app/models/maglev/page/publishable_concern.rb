# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Page::PublishableConcern
  def published?
    published_at.present?
  end

  def need_to_be_published?
    !published? || updated_at.blank? || updated_at > published_at
  end

  # opposite of #need_to_be_published?
  def published_and_up_to_date?
    published? && updated_at <= published_at
  end

  # called when a publishedpage is being previewed
  def apply_published_payload
    return unless !published? || published_payload.present?

    published_payload_attributes.each do |attribute|
      send("#{attribute}_translations=", published_payload["#{attribute}_translations"])
    end
  end

  # called when a page is being published
  def update_published_payload
    published_payload_attributes.each do |attribute|
      published_payload["#{attribute}_translations"] = send("#{attribute}_translations")
    end
  end

  private

  def published_payload_attributes
    %w[title seo_title meta_description og_title og_description og_image_url]
  end
end
# rubocop:enable Style/ClassAndModuleChildren
