# frozen_string_literal: true

module Maglev
  class Theme
    ## concerns ##
    include ActiveModel::Model

    ## attributes ##
    attr_accessor :id, :name, :description, :section_categories, :sections, :style_settings, :pages, :icons

    ## validations ##
    validates :id, :name, presence: true

    ## methods ##

    def find_setting!(section_id, block_id, setting_id)
      setting = find_setting(section_id, block_id, setting_id)
      raise Maglev::Errors::UnknownSetting.new(section_id, block_id, setting_id) if setting.nil?

      setting
    end

    def find_setting(section_id, block_id, setting_id)
      key = [section_id, block_id, setting_id].compact.join('.')
      section_setting_types[key]
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
  end
end
