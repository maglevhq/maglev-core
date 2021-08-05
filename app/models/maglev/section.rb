# frozen_string_literal: true

module Maglev
  class Section
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ::Maglev::Section::ContentConcern

    ## attributes ##
    attr_accessor :id, :theme, :name, :category, :scope, :settings, :blocks, :blocks_label, :blocks_presentation,
                  :sample

    ## validations ##
    validates :id, :theme, :name, :category, presence: true
    validates :settings, 'maglev/collection': true
    validates :blocks, 'maglev/collection': true

    ## methods ##
    def scoped_by_site?
      scope == 'site'
    end

    ## class methods ##
    def self.build(hash)
      attributes = hash.slice('id', 'theme', 'name', 'scope', 'category', 'blocks_label', 'blocks_presentation',
                              'sample')

      new(
        attributes.merge(
          settings: ::Maglev::Section::Setting.build_many(hash['settings']),
          blocks: ::Maglev::Section::Block.build_many(hash['blocks'])
        )
      )
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
