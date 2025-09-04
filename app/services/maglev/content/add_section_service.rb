# frozen_string_literal: true

class Maglev::Content::AddSectionService
  include Injectable

  dependency :fetch_theme
  dependency :fetch_site

  argument :page
  argument :section_type
  argument :position, default: -1

  def call
    raise Maglev::Errors::UnknownSection unless section_definition

    section_content = build_section_content(section_definition)

    ActiveRecord::Base.transaction do
      add_to_site!(section_content, section_definition)
      add_to_page!(section_content, section_definition)
    end

    section_content
  end

  private

  def add_to_site!(section_content, section_definition)
    return unless section_definition.site_scoped?

    site.sections_translations_will_change!
    # we don't care about the position for site scoped sections
    site.sections ||= []
    site.sections.push(section_content)
    site.prepare_sections(theme)

    site.save!
  end

  def add_to_page!(section_content, _section_definition)
    page.sections_translations_will_change!
    page.sections ||= []
    page.sections.insert(position, section_content)
    page.prepare_sections(theme)
    page.save!
  end

  def build_section_content(section_definition)
    section_definition.build_default_content.with_indifferent_access
  end

  def theme
    @theme ||= fetch_theme.call
  end

  def site
    @site ||= fetch_site.call
  end

  def section_definition
    @section_definition ||= theme.sections.find(section_type)
  end
end