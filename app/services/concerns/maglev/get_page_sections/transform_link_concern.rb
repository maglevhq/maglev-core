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
      link['href'] = anchor.present? ? "#{path}##{anchor}" : path
    end

    link
  end

  def get_fullpath_from_link(link)
    is_static_page = link['link_type'] == 'static_page'
    page_id = link['link_id']
    page = is_static_page ? fetch_static_pages.call.find { |static_page| static_page.id == page_id } : page_id

    # since the static pages don't have a preview version, we need the raw url
    preview_mode = is_static_page ? false : nil

    get_page_fullpath.call(page: page, locale: locale, preview_mode: preview_mode)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
