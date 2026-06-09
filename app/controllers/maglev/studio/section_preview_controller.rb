# frozen_string_literal: true

module Maglev
  module Studio
    # Renders a single section from default theme content on an in-memory page (no DB page load).
    # :slug is the theme section type (e.g. "showcase"). Disabled outside +Rails.env.local?+.
    class SectionPreviewController < ApplicationController
      include Maglev::RenderingConcern
      include Maglev::ServicesConcern
      include Maglev::ContentLocaleConcern

      rescue_from ActiveRecord::RecordNotFound, with: :respond_not_found
      rescue_from Maglev::Errors::UnknownSection, with: :respond_not_found

      before_action :fetch_maglev_site
      around_action :with_default_site_locale

      def show
        render_maglev_page
      end

      private

      def fetch_maglev_site
        super.tap do |site|
          raise ActiveRecord::RecordNotFound if site.nil?

          maglev_services.context.site = site
        end
      end

      def fetch_maglev_page
        @fetch_maglev_page ||= build_preview_page
      end

      def build_preview_page
        theme = fetch_maglev_theme
        section_content = build_section_content_for_preview(theme)

        Maglev::Page.new(title: 'Section preview', path: 'index').tap do |page|
          page.sections = [section_content]
          page.prepare_sections(theme)
        end
      end

      def build_section_content_for_preview(theme)
        definition = theme.sections.find(params[:slug].to_s)
        raise Maglev::Errors::UnknownSection unless definition

        definition.build_default_content.with_indifferent_access
      end

      def fetch_maglev_page_sections(*)
        section_id = fetch_maglev_page.sections.first.fetch('id')

        @fetch_maglev_page_sections ||= maglev_services.get_page_sections.call(
          page: fetch_maglev_page,
          section_id: section_id,
          locale: content_locale
        )
      end

      def maglev_rendering_mode
        :section
      end

      def with_default_site_locale(&block)
        Maglev::I18n.with_locale(maglev_site.default_locale_prefix, &block)
      end

      def respond_not_found
        head :not_found
      end
    end
  end
end
