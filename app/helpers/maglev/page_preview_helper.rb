# frozen_string_literal: true

module Maglev
  module PagePreviewHelper
    # rubocop:disable Rails/OutputSafety
    def render_maglev_sections(site: nil, theme: nil, page: nil, page_sections: nil)
      PageComponent.new(
        site: site || maglev_site,
        theme: theme || maglev_theme,
        page: page || maglev_page,
        page_sections: page_sections || maglev_page_sections,
        context: maglev_rendering_context
      ).tap { |component| component.view_context = self }.render.html_safe
    end
    # rubocop:enable Rails/OutputSafety

    def render_maglev_section(type, site: nil, theme: nil, page: nil, page_sections: nil)
      sections = (page_sections || maglev_page_sections).find_all do |section|
        (section['type'] || section[:type]).start_with?(type.to_s)
      end

      render_maglev_sections(
        site: site,
        theme: theme,
        page: page,
        page_sections: sections
      )
    end

    def render_maglev_alternate_links(links: nil, x_default_locale: nil)
      links ||= maglev_page_fullpaths
      x_default_locale ||= maglev_site.default_locale_prefix.to_sym

      return '' if links.blank? || links.size < 2

      safe_join(
        [tag.link(rel: 'alternate', hreflang: 'x-default', href: maglev_alt_link(x_default_locale))] +
        links.map do |(locale, _link)|
          tag.link(rel: 'alternate', hreflang: locale, href: maglev_alt_link(locale))
        end
      )
    end

    def maglev_alt_link(locale, links: nil)
      links ||= maglev_page_fullpaths
      link = links[locale.to_sym]
      return nil if link.nil?

      "#{request.base_url}#{link}"
    end

    def maglev_site_link
      maglev_site_root_fullpath
    end

    def maglev_current_locale?(locale)
      locale.to_sym == maglev_content_locale
    end

    def maglev_rendering_context
      {
        templates_root_path: maglev_sections_path,
        rendering_mode: maglev_rendering_mode,
        config: maglev_config
      }
    end

    def rendering_maglev_page?
      controller.class.module_parent.to_s == 'Maglev'
    end
  end
end
