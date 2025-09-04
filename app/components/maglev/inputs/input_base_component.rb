# frozen_string_literal: true

module Maglev
  module Inputs
    class InputBaseComponent < ViewComponent::Base
      attr_reader :setting, :value, :scope, :i18n_scope

      def initialize(setting:, value:, scope:, i18n_scope:)
        @setting = setting
        @value = value
        @scope = scope  
        @i18n_scope = i18n_scope
      end

      def input_name
        "#{scope}[#{setting.id}]"
      end

      def label
        ::I18n.t("#{i18n_scope}.settings.#{setting.id}", default: setting.label)
      end
      
      def call
        content_tag(:div, "Unknown input type: #{setting.type}", class: 'bg-red-500 text-white p-4 rounded-md')
      end
    end
  end
end
