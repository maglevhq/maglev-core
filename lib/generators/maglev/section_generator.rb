# frozen_string_literal: true

module Maglev
  class SectionGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/section', __dir__)

    class_option :name, type: :string, default: nil
    class_option :category, type: :string, default: nil
    class_option :settings, type: :array, default: []

    hook_for :maglev_section

    attr_reader :theme_name, :section_name, :category, :settings, :blocks

    def set_section_name
      @section_name = options['name'] || file_name.humanize
    end

    def verify_theme_exists
      raise Thor::Error, set_color('ERROR: You must first create a theme.', :red) if theme.nil?
    end

    def verify_categories_exist
      raise Thor::Error, set_color('ERROR: You must add categories to your theme.', :red) if categories.blank?
    end

    def select_category
      @category = options['category']

      return if @category.present? && categories.include?(@category)

      say 'You have to select a category for your section. Please check your Maglev theme.yml file to manage them.',
          :blue
      @category = ask 'Please choose a category', limited_to: categories, default: categories.first
    end

    def build_settings
      @settings = extract_section_settings
      @blocks = extract_blocks
    end

    def create_section_files
      directory 'app'
    end

    private

    def theme
      Maglev.local_themes&.first
    end

    def categories
      theme.section_categories.map(&:id)
    end

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

      # rubocop:disable Metrics/CyclomaticComplexity
      def default
        case type
        when 'text' then label
        when 'image' then '"/theme/image-placeholder.jpg"'
        when 'checkbox' then true
        when 'link' then '{ text: "Link", href: "#" }'
        when 'color' then '#E5E7EB'
        when 'radio', 'select' then 'option_1'
        when 'icon' then 'default-icon-class'
        when 'collection_item' then 'any'
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity

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
