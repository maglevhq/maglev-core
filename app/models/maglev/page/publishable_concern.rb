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
      send("#{attribute}=", published_payload[attribute])
    end
  end

  # called when a page is being published
  def update_published_payload
    published_payload_attributes.each do |attribute|
      published_payload[attribute] = send(attribute.to_sym)
    end
  end

  private

  def published_payload_attributes
    published_payload_core_attributes + published_payload_additional_attributes
  end

  def published_payload_additional_attributes
    # override this method to add additional attributes to the published payload
    []
  end

  def published_payload_core_attributes
    %w[title_translations seo_title_translations meta_description_translations og_title_translations
       og_description_translations og_image_url_translations]
  end
end
# rubocop:enable Style/ClassAndModuleChildren
