# frozen_string_literal: true

module Maglev
  module Content
    class SettingContent
      include ActiveModel::Model

      attr_accessor :id, :type, :value

      class AssociationProxy
        include Enumerable

        attr_reader :settings

        def initialize(raw_settings)
          @settings = raw_settings.map { |raw_setting| Maglev::Content::SettingContent.new(raw_setting) }
        end

        def [](id)
          settings.find { |s| s.id == id }
        end

        def value_of(id)
          self[id]&.value
        end

        def each(&block)
          settings.each(&block)
        end
      end
    end
  end
end
