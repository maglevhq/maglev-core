# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::GetPageSections::TransformLinkConcern
  def transform_link_content_setting(content, _setting)
    return unless content['value'].is_a?(Hash) && %w[page static_page].include?(content.dig('value', 'link_type'))

    content['value'] = replace_href_in_link(content['value'])
  end

  def replace_href_in_link(link)
    path = get_fullpath_from_link(link)

    if path
      anchor = link['section_id']
      link['href'] = anchor.present? ? "#{path}#section-#{anchor}" : path
    end

    link
  end

  def get_fullpath_from_link(link)
    is_static_page = link['link_type'] == 'static_page'
    page_id = link['link_id']

    # since the static pages don't have a preview version, we need the raw url
    if is_static_page
      page = fetch_static_pages.call.find { |static_page| static_page.id == page_id }
      page&.path
    else
      get_page_fullpath.call(page: page_id, locale: locale)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
