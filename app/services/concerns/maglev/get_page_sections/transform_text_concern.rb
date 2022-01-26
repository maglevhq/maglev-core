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
    return unless link_type_matches && link_id_matches

    # rubocop:disable Style/StringHashKeys
    link = { 'link_type' => link_type_matches[1], 'link_id' => link_id_matches[1] }
    # rubocop:enable Style/StringHashKeys

    return unless %w[page static_page].include?(link['link_type'])

    link['section_id'] = section_id_matches[1] if section_id_matches

    replace_href_in_link(link)['href']
  end
end
# rubocop:enable Style/ClassAndModuleChildren
