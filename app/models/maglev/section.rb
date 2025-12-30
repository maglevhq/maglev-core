# frozen_string_literal: true

# Definition of a section in the theme
# Don't misunstand it with the content of a section within a page or a site
module Maglev
  class Section
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ::Maglev::Section::ContentConcern

    HASH_ATTRIBUTES = %w[id theme name site_scoped singleton viewport_fixed_position insert_button max_width_pane
                         insert_at category blocks_label blocks_presentation sample screenshot_timestamp].freeze

    ## attributes ##
    attr_accessor :id, :theme, :name, :category,
                  :site_scoped, :singleton, :viewport_fixed_position,
                  :insert_button, :insert_at, :max_width_pane,
                  :settings, :blocks, :blocks_label, :blocks_presentation,
                  :sample, :screenshot_timestamp

    ## validations ##
    validates :id, :theme, :name, :category, presence: true
    validates :settings, 'maglev/collection': true
    validates :blocks, 'maglev/collection': true

    ## methods ##

    def human_name
      ::I18n.t("#{i18n_scope}.name", default: name.humanize)
    end

    def human_blocks_label(default = nil)
      ::I18n.t("#{i18n_scope}.blocks.label", default: blocks_label || default)
    end

    def site_scoped?
      !!site_scoped
    end

    def singleton?
      !!singleton
    end

    def root_blocks
      blocks.select(&:root?)
    end

    def blocks_tree?
      blocks_presentation == 'tree'
    end

    def accepts_blocks?
      blocks.any? { |block| block.accept.present? }
    end

    def viewport_fixed_position?
      !!viewport_fixed_position
    end

    def main_settings
      settings.reject(&:advanced?)
    end

    def advanced_settings
      settings.select(&:advanced?)
    end

    def assign_attributes_from_yaml(hash)
      attributes = prepare_default_attributes(hash).merge(
        settings: ::Maglev::Section::Setting.build_many(hash['settings']),
        blocks: ::Maglev::Section::Block::Store.new(hash['blocks'], section: self)
      )

      assign_attributes(attributes)
    end

    def i18n_scope
      "maglev.themes.#{theme.id}.sections.#{id}"
    end

    ## class methods ##

    def self.build(hash)
      new.tap do |section|
        section.assign_attributes_from_yaml(hash)
      end
    end

    ## private methods ##

    private

    def prepare_default_attributes(hash)
      attributes = hash.slice(*HASH_ATTRIBUTES)

      %w[site_scoped singleton viewport_fixed_position max_width_pane].each do |name|
        attributes[name] = false if attributes[name].nil?
      end

      attributes['insert_button'] = true if attributes['insert_button'].nil?

      attributes
    end

    class Store
      extend Forwardable
      def_delegators :@array, :all, :first, :last, :count, :each, :each_with_index, :map, :group_by, :select

      attr_reader :array

      def initialize(array)
        @array = array
      end

      def find(type)
        @array.find { |section| section.id == type }
      end

      def find_all_by_type(type)
        @array.select { |section| section.id == type }
      end

      def group_by_category
        @array.group_by(&:category)
      end

      def available_for(store_content)
        # we don't want to add site_scoped sections or singleton sections that are already present in the store
        self.class.new(store_content.addable_sections)
      end

      def as_json(**_options)
        @array.as_json
      end
    end
  end
end
