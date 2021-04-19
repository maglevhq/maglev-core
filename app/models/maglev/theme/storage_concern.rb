# frozen_string_literal: true

# rubocop:disable Style/ClassAndModuleChildren
module Maglev::Theme::StorageConcern
  extend ActiveSupport::Concern

  included do
    class << self
      extend Forwardable
      def_delegators :store, :load!

      def store
        @store ||= Store.new
      end

      def default
        store.theme
      end
    end
  end

  class Store
    attr_reader :theme

    def initialize
      @theme = nil
    end

    def load!
      @theme = nil
      path = Rails.root.join('app/theme/theme.yml')
      @theme = add(YAML.safe_load(File.read(path)))
      sections = load_sections(@theme, Rails.root.join('app/theme/sections/**/*.yml'))
      @theme.sections = Maglev::Section::Store.new(sections)
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
# rubocop:enable Style/ClassAndModuleChildren
