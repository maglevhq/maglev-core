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

        Maglev::Page.new(
          title: 'Section preview',
          path: 'index',
          layout_id: theme.default_layout_id || theme.layouts.first&.id
        )
      end

      def section_definition
        @section_definition ||= fetch_maglev_theme.sections.find(params[:slug].to_s).tap do |definition|
          raise Maglev::Errors::UnknownSection unless definition
        end
      end

      def fetch_maglev_page_sections(*)
        @fetch_maglev_page_sections ||= build_maglev_page_sections
      end

      def build_maglev_page_sections
        theme = fetch_maglev_theme
        layout = theme.find_layout(fetch_maglev_page.layout_id)
        target_group = layout.groups.find { |group| group.accepts?(section_definition) } || layout.groups.first
        store = build_preview_store(theme)

        layout.groups.map do |group|
          build_maglev_page_sections_group(group, target_group, store)
        end
      end

      def build_preview_store(theme)
        Maglev::SectionsContentStore.new(handle: 'studio_section_preview').tap do |store|
          store.sections = [section_definition.build_default_content.with_indifferent_access]
          store.prepare_sections(theme)
        end
      end

      def build_maglev_page_sections_group(group, target_group, store)
        {
          id: group.id,
          handle: group.handle,
          sections: group.id == target_group.id ? store.sections : [],
          lock_version: nil
        }
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
