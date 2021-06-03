# frozen_string_literal: true

module Maglev
  class Theme
    ## concerns ##
    include ActiveModel::Model

    ## attributes ##
    attr_accessor :id, :name, :description, :section_categories, :sections, :pages, :sections_path

    ## validations ##
    validates :id, :name, presence: true

    ## methods ##

    # I would move this to FilesystemThemeLoader class later on
    # maybe in the future we can store themes in other places, like the DB
    class << self
      def load(path)
        theme = add(YAML.safe_load(File.read(path.join('theme.yml'))))
        sections = load_sections(theme, Pathname.new(path).join('sections/**/*.yml'))
        theme.sections = Maglev::Section::Store.new(sections)
        theme
      rescue Errno::ENOENT
        Kernel.puts 'Missing file(s) in app/theme/'
      end

      def load_sections(theme, source_path)
        Dir.glob(source_path).map do |path|
          section_id = File.basename(path, '.yml')
          attributes = YAML.safe_load(File.read(path)).with_indifferent_access
          attributes.merge!(id: section_id, theme: theme)
          Maglev::Section.build(attributes)
        end
      end

      def add(hash)
        attributes = hash.merge(
          section_categories: Maglev::Theme::SectionCategory.build_many(hash['section_categories']),
          sections: []
        )

        Maglev::Theme.new(attributes).tap do |theme|
          Rails.logger.info("[Maglev] adding theme: #{theme.name} (##{theme.id})")
        end
      end
    end
  end
end
