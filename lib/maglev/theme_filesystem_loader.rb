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

    SPACING_SETTINGS = [
      { 'label' => 'Marge en haut',          'id' => 'spacing_top',    'type' => 'checkbox', 'default' => false },
      { 'label' => 'Marge en bas',           'id' => 'spacing_bottom', 'type' => 'checkbox', 'default' => false },
      {
        'label' => "Taille de l'espacement",
        'id' => 'spacing_size',
        'type' => 'select',
        'default' => 'md',
        'select_options' => [
          { 'label' => 'Très petit (xs)', 'value' => 'xs' },
          { 'label' => 'Petit (sm)',      'value' => 'sm' },
          { 'label' => 'Moyen (md)',      'value' => 'md' },
          { 'label' => 'Grand (lg)',      'value' => 'lg' },
          { 'label' => 'Très grand (xl)', 'value' => 'xl' }
        ]
      }
    ].freeze

    BUTTON_TYPE_SETTING = {
      'label' => 'Forme du bouton',
      'id' => 'button_type',
      'type' => 'select',
      'default' => 'button',
      'select_options' => [
        { 'label' => 'Plein', 'value' => 'button' },
        { 'label' => 'Contour', 'value' => 'outline' }
      ]
    }.freeze

    BUTTON_VARIANT_SETTING = {
      'label' => 'Couleur du bouton',
      'id' => 'button_variant',
      'type' => 'select',
      'default' => 'primary',
      'select_options' => [
        { 'label' => 'Orange (primary)', 'value' => 'primary' },
        { 'label' => 'Prune / Violet (secondary)', 'value' => 'secondary' },
        { 'label' => 'Vert (success)', 'value' => 'success' },
        { 'label' => 'Rouge (danger)', 'value' => 'danger' },
        { 'label' => 'Jaune (warning)', 'value' => 'warning' },
        { 'label' => 'Blanc (info)', 'value' => 'info' },
        { 'label' => 'Noir (dark)', 'value' => 'dark' },
        { 'label' => 'Crème (light)', 'value' => 'light' },
        { 'label' => 'Lien sans bouton (link)', 'value' => 'link' }
      ]
    }.freeze

    def build_section(theme, section_id, attributes)
      attributes['settings'] ||= []

      inject_spacing_settings(attributes) if section_id != 'spacer'
      inject_button_variant_setting(attributes)

      section = Maglev::Section.build(
        attributes.merge(id: section_id, theme: theme)
      )
      section.screenshot_timestamp = find_section_screenshot_timestamp(theme, section)
      section
    end

    def inject_spacing_settings(attributes)
      return if setting_ids(attributes['settings']).include?('spacing_top')

      attributes['settings'] += SPACING_SETTINGS.map(&:dup)
    end

    def inject_button_variant_setting(attributes)
      settings = attributes['settings'] || []
      ids = setting_ids(settings)
      return unless ids.include?('button_text') || ids.include?('button_link')

      unless ids.include?('button_type')
        idx = settings.find_index { |s| (s['id'] || s[:id]).to_s == 'button_text' }
        idx ||= settings.find_index { |s| (s['id'] || s[:id]).to_s == 'button_link' }
        if idx
          settings.insert(idx + 1, BUTTON_TYPE_SETTING.dup)
        else
          settings << BUTTON_TYPE_SETTING.dup
        end
      end

      recalculated_ids = setting_ids(settings)
      return if recalculated_ids.include?('button_variant')

      idx = settings.find_index { |s| (s['id'] || s[:id]).to_s == 'button_type' }
      idx ||= settings.find_index { |s| (s['id'] || s[:id]).to_s == 'button_text' }
      idx ||= settings.find_index { |s| (s['id'] || s[:id]).to_s == 'button_link' }
      if idx
        settings.insert(idx + 1, BUTTON_VARIANT_SETTING.dup)
      else
        settings << BUTTON_VARIANT_SETTING.dup
      end
    end

    def setting_ids(settings)
      settings.map { |s| (s['id'] || s[:id]).to_s }
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
