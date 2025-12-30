# frozen_string_literal: true

module Maglev
  class Theme
    ## concerns ##
    include ActiveModel::Model

    ## attributes ##
    attr_accessor :id, :name, :description, :section_categories, :layouts, :sections, :style_settings, :pages, :icons, :mirror_section

    ## validations ##
    validates :id, :name, presence: true

    ## methods ##

    def initialize(...)
      super
      attach_theme_to_associations
    end

    def find_layout(layout_id)
      layouts.find { |layout| layout.id == layout_id }
    end

    def find_setting!(section_id, block_id, setting_id)
      setting = find_setting(section_id, block_id, setting_id)
      raise Maglev::Errors::UnknownSetting.new(section_id, block_id, setting_id) if setting.nil?

      setting
    end

    def find_setting(section_id, block_id, setting_id)
      key = [section_id, block_id, setting_id].compact.join('.')
      section_setting_types[key]
    end

    def find_layout(layout_id)
      layouts.find { |layout| layout.id == layout_id }
    end

    def default_layout_id
      layouts.size == 1 ? layouts.first.id : nil
    end

    def style?
      style_settings.present?
    end

    def mirror_section?
      !!mirror_section
    end

    private

    def section_setting_types
      @section_setting_types ||= build_section_setting_types
    end

    def build_section_setting_types
      hash = {}
      sections.each do |section|
        build_section_setting_types_from_settings(hash, section.id, section.settings)
        section.blocks.each do |block|
          build_section_setting_types_from_settings(hash, "#{section.id}.#{block.type}", block.settings)
        end
      end
      hash
    end

    def build_section_setting_types_from_settings(hash, parent_key, settings)
      settings.each do |setting|
        hash["#{parent_key}.#{setting.id}"] = setting
      end
    end

    def attach_theme_to_associations
      section_categories&.each { |category| category.theme = self }
    end
  end
end
