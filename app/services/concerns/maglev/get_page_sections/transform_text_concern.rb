# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::GetPageSections::TransformTextConcern
  def transform_text_content_setting(content, setting)
    return unless setting.options['html']

    content['value'] = replace_links_in_text(content['value'])
  end

  def replace_links_in_text(text)
    text.gsub(/<a([^>]+)>/) do |tag|
      link_type_matches = tag.match(/maglev-link-type="([^"]+)"/)
      link_id_matches = tag.match(/maglev-link-id="([^"]+)"/)
      section_id_matches = tag.match(/maglev-section-id="([^"]+)"/)
      path = find_link_page_path(link_type_matches, link_id_matches, section_id_matches)

      tag.gsub!(/href="([^"]+)"/, "href=\"#{path}\"") if path

      tag
    end
  end

  def find_link_page_path(link_type_matches, link_id_matches, section_id_matches)
    return unless link_type_matches && link_id_matches && link_type_matches[1] == 'page'

    path = get_page_fullpath.call(page: link_id_matches[1])
    anchor = section_id_matches ? section_id_matches[1] : nil
    anchor.present? ? "#{path}##{anchor}" : path
  end
end
# rubocop:enable Style/ClassAndModuleChildren
