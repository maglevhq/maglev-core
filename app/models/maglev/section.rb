# frozen_string_literal: true

module Maglev
  class Section
    include ActiveModel::Model
    include ::Maglev::Section::ContentConcern
    include ::Maglev::Section::ScreenshotConcern

    ## attributes ##
    attr_accessor :id, :name, :category, :settings, :blocks, :blocks_label

    ## validations ##
    validates :id, :name, :category, presence: true
    validates :settings, 'maglev/collection': true
    validates :blocks, 'maglev/collection': true

    ## class methods ##
    def self.build(hash)
      attributes = hash.slice('id', 'name', 'category', 'blocks_label')

      new(
        attributes.merge(
          settings: ::Maglev::Section::Setting.build_many(hash['settings']),
          blocks: ::Maglev::Section::Block.build_many(hash['blocks'])
        )
      )
    end

    def as_json
      {
        id: id, name: name, category: category,
        settings: settings, blocks: blocks, blocks_label: blocks_label,
        screenshot_path: screenshot_path
      }.as_json
    end

    class Store
      extend Forwardable
      def_delegators :@array, :all, :first, :last, :count, :each, :each_with_index

      attr_reader :array

      def initialize(array)
        @array = array
      end

      def find(id)
        @array.find { |section| section.id == id }
      end

      def as_json(**_options)
        @array.as_json
      end
    end
  end
end
