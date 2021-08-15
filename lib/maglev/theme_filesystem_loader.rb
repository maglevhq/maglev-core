# frozen_string_literal: true

module Maglev
  class ThemeFilesystemLoader
    attr_reader :fetch_screenshot_path

    def initialize(fetch_screenshot_path)
      @fetch_screenshot_path = fetch_screenshot_path
    end

    def call(path)
      theme = add(YAML.safe_load(File.read(path.join('theme.yml'))))
      sections = load_sections(theme, Pathname.new(path).join('sections/**/*.yml'))
      theme.sections = Maglev::Section::Store.new(sections)
      theme
    rescue Errno::ENOENT
      Kernel.puts "Missing theme file(s) in #{path}"
    end

    private

    def add(hash)
      attributes = hash.merge(
        section_categories: Maglev::Theme::SectionCategory.build_many(hash['section_categories']),
        sections: []
      )

      Maglev::Theme.new(attributes).tap do |theme|
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
      path = fetch_screenshot_path.call(theme: theme, section: section, absolute: true)
      File.exist?(path) ? File.mtime(path).to_i : nil
    end
  end
end
