# frozen_string_literal: true

module Maglev
  module Editor
    module Settings
      class BaseComponent < ViewComponent::Base
        attr_reader :definition, :value, :paths, :input_scope, :i18n_scope

        def initialize(definition:, value:, paths:, scope:)
          @definition = definition
          @value = value
          @paths = paths
          @input_scope = scope[:input]
          @i18n_scope = scope[:i18n]

          after_initialize
        end

        def input_name
          "#{input_scope}[#{definition.id}]"
        end

        def input_source
          input_name.parameterize.underscore
        end

        def label
          ::I18n.t("#{i18n_scope}.settings.#{definition.id}", default: definition.label)
        end

        def placeholder
          ::I18n.t("#{i18n_scope}.settings.#{definition.id}_placeholder")
        end

        def call
          content_tag(:div, "Unknown setting type: #{definition.type} / #{definition.options}",
                      class: 'bg-red-500 text-white p-4 rounded-md')
        end

        def fetch_path(name, context = {})
          path_or_proc = paths.fetch(name, nil)
          path_or_proc.is_a?(Proc) ? path_or_proc.call(definition, context) : path_or_proc
        end

        def after_initialize
          # to be overridden by subclasses
        end
      end
    end
  end
end
