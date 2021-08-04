# frozen_string_literal: true

module Maglev
  module PagePreviewHelper
    def render_maglev_sections(site:, theme:, page:, page_sections:)
      PageComponent.new(
        site: site,
        theme: theme,
        page: page,
        page_sections: page_sections,
        templates_root_path: fetch_sections_path
      ).tap { |component| component.view_context = self }.render
    end

    # def maglev_section_tag
    #   MaglevTagBuilder.new(self, @maglev_section)
    # end

    # def maglev_image_tag(setting_id); end

    # class MaglevTagBuilder < ActionView::Helpers::TagHelper::TagBuilder
    #   attr_reader :maglev_object

    #   def initialize(view_context, maglev_object)
    #     super(view_context)
    #     @maglev_object = maglev_object
    #   end

    #   def tag_options(options, escape = true)
    #     if options.blank?
    #       options = { data: maglev_object.tag_data }
    #     else
    #       options[:data] = (options[:data] || {}).merge(maglev_object.tag_data)
    #     end
    #     super(options, escape)
    #   end
    # end
  end
end
