# frozen_string_literal: true

module Maglev
  class SectionGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/section', __dir__)

    class_option :category, type: :string, default: 'contents'
    class_option :settings, type: :array, default: []

    hook_for :maglev_section

    attr_reader :theme_name, :settings, :blocks

    def verify_theme_exists
      raise Thor::Error, set_color('ERROR: You must first create a theme.', :red) if Maglev.local_themes.blank?
    end

    def build_settings
      @settings = extract_section_settings
      @blocks = extract_blocks
    end

    def create_section_files
      directory 'app'
    end

    private

    def extract_section_settings
      return default_section_settings if options['settings'].blank?

      # build section settings only
      options['settings'].map do |raw_setting|
        next if raw_setting.starts_with?('block:') # block setting

        id, type = raw_setting.split(':')
        SectionSetting.new(id, type)
      end.compact.presence
    end

    def extract_blocks
      # build block settings
      blocks = options['settings'].map do |raw_setting|
        next unless raw_setting.starts_with?('block:') # block setting

        _, block_type, id, type = raw_setting.split(':')
        BlockSetting.new(block_type, id, type)
      end.compact.presence || []

      blocks = default_block_settings if blocks.blank? && @settings.blank?

      # group them by block types
      blocks.group_by(&:block_type)
    end

    def default_section_settings
      [
        SectionSetting.new('title', 'text', 'My awesome title'),
        SectionSetting.new('image', 'image', 'An image')
      ]
    end

    def default_block_settings
      [
        BlockSetting.new('list_item', 'title', 'text', 'Item title'),
        BlockSetting.new('list_item', 'image', 'image', 'Item image')
      ]
    end

    class SectionSetting
      attr_reader :id, :type, :label

      def initialize(id, type, label = nil)
        @id = id
        @type = type || 'text'
        @label = label || id.humanize
      end

      def default
        case type
        when 'text' then label
        when 'image' then '"/theme/image-placeholder.jpg"'
        when 'checkbox' then true
        when 'link' then '"#"'
        when 'color' then '#E5E7EB'
        when 'radio', 'select' then 'option_1'

        end
      end

      def value?
        !%w[hint content_type].include?(type)
      end
    end

    class BlockSetting < SectionSetting
      attr_reader :block_type

      def initialize(block_type, id, type, label = nil)
        super(id, type, label)
        @block_type = block_type
      end
    end
  end
end
