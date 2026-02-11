# frozen_string_literal: true

module Maglev
  class HasUnpublishedChanges
    include Injectable

    argument :site
    argument :page
    argument :theme

    def call
      page.need_to_be_published? || site_need_to_be_published?
    end

    private

    def site_need_to_be_published?
      !site.published? || site.updated_at.blank? || site.updated_at > site.published_at
    end
  end
end
