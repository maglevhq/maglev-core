# frozen_string_literal: true

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

    def site_scoped?
      !!site_scoped
    end

    def singleton?
      !!singleton
    end

    def viewport_fixed_position?
      !!viewport_fixed_position?
    end

    def assign_attributes_from_yaml(hash)
      attributes = prepare_default_attributes(hash).merge(
        settings: ::Maglev::Section::Setting.build_many(hash['settings']),
        blocks: ::Maglev::Section::Block.build_many(hash['blocks'])
      )

      assign_attributes(attributes)
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
      def_delegators :@array, :all, :first, :last, :count, :each, :each_with_index, :map, :group_by

      attr_reader :array

      def initialize(array)
        @array = array
      end

      def find(id)
        @array.find { |section| section.id == id }
      end

      def grouped_by_category
        @array.group_by(&:category)
      end

      def as_json(**_options)
        @array.as_json
      end
    end
  end
end
