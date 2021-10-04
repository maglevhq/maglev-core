# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::GetPageSections::TransformLinkConcern
  def transform_link_content_setting(content, _setting)
    return unless content['value'].is_a?(Hash) && content.dig('value', 'link_type') == 'page'

    content['value'] = replace_href_in_link(content['value'])
  end

  def replace_href_in_link(link)
    path = get_page_fullpath.call(page: link['link_id'])
    if path
      anchor = link['section_id']
      link['href'] = anchor.present? ? "#{path}##{anchor}" : path
    end
    link
  end
end
# rubocop:enable Style/ClassAndModuleChildren
