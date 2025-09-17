# frozen_string_literal: true

module Maglev
  module Editor
    class SettingsGroupComponent < ViewComponent::Base
      attr_reader :values, :definitions, :paths, :scope

      def initialize(values:, definitions:, scope:, paths: {})
        @values = values
        @definitions = definitions
        @paths = paths
        @scope = scope
      end

      def setting_instance_for(definition)
        component_klass = Maglev::Editor::SettingRegistry.instance.fetch(definition)
        component_klass.new(
          definition: definition,
          value: value_of(definition.id),
          paths: paths,
          scope: scope
        )
      end

      def value_of(definition_id)
        values.find { |value| value.id == definition_id }&.value
      end
    end
  end
end
