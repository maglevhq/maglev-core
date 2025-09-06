class Maglev::Content::UpdateSectionBlockService
  include Injectable
  include Maglev::Content::HelpersConcern

  dependency :fetch_theme
  dependency :fetch_site

  argument :page
  argument :section_id
  argument :block_id
  argument :content

  def call
    raise Maglev::Errors::UnknownSection unless section_definition
    raise Maglev::Errors::UnknownBlock unless block_definition

    ActiveRecord::Base.transaction do
      update_section_block_content!(site) if site_scoped?
      update_section_block_content!(page)
    end
  end

  private 

  def update_section_block_content!(source)
    source.sections_translations_will_change!
    update_section_block_content(source)
    source.save!
  end

  def update_section_block_content(source)
    current_section_block_content = find_block_content(source)

    block_definition.settings.each do |setting|
      next unless content.key?(setting.id.to_sym)

      update_setting_value(setting, current_section_block_content)
    end
  end
end

# class Maglev::Content::UpdateSectionBlockService
#   include Injectable

#   dependency :fetch_theme
#   dependency :fetch_site

#   argument :page
#   argument :section_id
#   argument :block_id
#   argument :content

#   def call
#     raise Maglev::Errors::UnknownSection unless section_definition
#     raise Maglev::Errors::UnknownBlock unless block_definition

#     ActiveRecord::Base.transaction do
#       update_section_block_content!(site) if site_scoped?
#       update_section_block_content!(page)
#     end
#   end

#   private 

#   def theme
#     @theme ||= fetch_theme.call
#   end

#   def site
#     @site ||= fetch_site.call
#   end

#   def site_scoped?
#     section_definition.site_scoped?
#   end

#   def section_definition
#     # use the page to find the section definition
#     @section_definition ||= theme.sections.find(
#       page.find_section_by_id(section_id)&.fetch('type', nil)
#     )
#   end

#   def block_definition
#     # use the page to find the block definition
#     block_type = fetch_section_block_type(page)
#     @block_definition ||= section_definition.blocks.find(block_type)
#   end

#   def update_section_block_content!(source)
#     source.sections_translations_will_change!
#     update_section_block_content(source)
#     source.save!
#   end

#   def update_section_block_content(source)
#     current_section_block_content = fetch_section_block_content(source)

#     block_definition.settings.each do |setting|
#       next unless content.key?(setting.id.to_sym)

#       update_setting_value(setting, current_section_block_content)
#     end
#   end

#   def fetch_section_block(source)
#     source
#     .find_section_by_id(section_id)
#     .dig('blocks')
#     .find { |block| block['id'] == block_id }
#   end

#   def fetch_section_block_type(source)
#     fetch_section_block(source).dig('type')
#   end

#   def fetch_section_block_content(source)
#     fetch_section_block(source).dig('settings')
#   end

#   def update_setting_value(setting, current_section_block_content)
#     setting_content = current_section_block_content.find { |s| s['id'] == setting.id }
#     value = content[setting.id.to_sym]

#     if setting_content.nil?
#       current_section_block_content.push({ id: setting.id, value: value })
#     else
#       setting_content['value'] = value
#     end
#   end
# end