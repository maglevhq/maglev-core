# frozen_string_literal: true

module Maglev
  class ThemeFilesystemLoader
    attr_reader :fetch_section_screenshot_path

    def initialize(fetch_section_screenshot_path)
      @fetch_section_screenshot_path = fetch_section_screenshot_path
    end

    def call(path)
      theme = add(YAML.safe_load(File.read(path.join('theme.yml')), aliases: true))
      sections = load_sections(theme, Pathname.new(path).join('sections/**/*.yml'))
      detect_duplicate_sections(sections)
      theme.sections = Maglev::Section::Store.new(sections)
      theme
    rescue Errno::ENOENT
      log_missing_theme_file(path)
    end

    private

    def add(hash)
      attributes = hash.merge(
        section_categories: Maglev::Theme::SectionCategory.build_many(hash['section_categories']),
        style_settings: Maglev::Theme::StyleSetting.build_many(hash['style_settings']),
        sections: []
      )

      Maglev::Theme.new(HashWithIndifferentAccess.new(attributes)).tap do |theme|
        Rails.logger.info("[Maglev] adding theme: #{theme.name} (##{theme.id})")
      end
    end

    def load_sections(theme, source_path)
      Dir.glob(source_path).map do |path|
        section_id = File.basename(path, '.yml')
        attributes = YAML.safe_load(File.read(path)).with_indifferent_access
        build_section(theme, section_id, attributes)
      end
    end

    def build_section(theme, section_id, attributes)
      section = Maglev::Section.build(
        attributes.merge(id: section_id, theme: theme)
      )
      section.screenshot_timestamp = find_section_screenshot_timestamp(theme, section)
      section
    end

    def find_section_screenshot_timestamp(theme, section)
      path = fetch_section_screenshot_path.call(theme: theme, section: section, absolute: true)
      File.exist?(path) ? File.mtime(path).to_i : nil
    end

    def detect_duplicate_sections(sections)
      sections.group_by(&:id).each do |id, list|
        raise Maglev::Errors::DuplicateSectionDefinition, "Duplicate section definition: #{id}" if list.size > 1
      end
    end

    def log_missing_theme_file(path)
      # don't log the error if the ruby code is not executed inside
      # the Rails console or when the Rails server is running
      return if !Rails.const_defined?('Console') && !Rails.const_defined?('Server')

      Kernel.puts "Missing theme file(s) in #{path}"
    end
  end
end
