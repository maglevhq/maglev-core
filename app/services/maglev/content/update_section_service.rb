# frozen_string_literal: true

class Maglev::Content::UpdateSectionService
  include Injectable

  dependency :fetch_theme
  dependency :fetch_site

  argument :page
  argument :section
  argument :content

  def call
    raise Maglev::Errors::UnknownSection unless section_definition
    
    ActiveRecord::Base.transaction do
      update_section_content!(site, section, content) if site_scoped?
      update_section_content!(page, section, content)      
    end   
  end

  private

  def update_section_content!(source, section, content)
    source.sections_translations_will_change!
    current_section_content = source.sections.find { |s| s['id'] == section.id }['settings']

    section.settings.each do |setting|
      next unless content.has_key?(setting.id.to_sym)

      setting_content = current_section_content.find { |s| s['id'] == setting.id }
    
      setting_content['value'] = content[setting.id.to_sym]
    end

    source.save!
  end

  def section_definition
    theme.sections.find(section.type)
  end

  def site_scoped?
    section_definition.site_scoped?
  end

  def theme
    @theme ||= fetch_theme.call
  end

  def site
    @site ||= fetch_site.call
  end
end