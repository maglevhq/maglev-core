# frozen_string_literal: true

module Maglev
  module Inputs
    class InputBaseComponent < ViewComponent::Base
      attr_reader :definition, :value, :scope, :i18n_scope

      def initialize(definition:, value:, scope:, i18n_scope:)
        @definition = definition
        @value = value
        @scope = scope
        @i18n_scope = i18n_scope
      end

      def input_name
        "#{scope}[#{definition.id}]"
      end

      def label
        ::I18n.t("#{i18n_scope}.settings.#{definition.id}", default: definition.label)
      end

      def call
        content_tag(:div, "Unknown input type: #{definition.type} / #{definition.options}",
                    class: 'bg-red-500 text-white p-4 rounded-md')
      end
    end
  end
end
