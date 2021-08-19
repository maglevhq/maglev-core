# frozen_string_literal: true

module Maglev
  module TagHelper
    def wrapper_tag(options = nil, &block)
      return WrapperTagBuilder.new(view_context, self) if options.nil?

      tag_options = options || {}
      tag_options[:data] = (tag_options[:data] || {}).merge(tag_data)
      content = view_context.capture(&block)
      view_context.tag.public_send(
        tag_options.delete(:html_tag) || :div,
        content,
        **tag_options
      )
    end

    def setting_tag(setting_id, options = {}, &block)
      # content = view_context.capture(&block) if block_given?
      # setting = settings.public_send(setting_id)
      # setting.tag(view_context, options, content)
      setting = settings.public_send(setting_id)
      setting.tag(view_context, options, &block)
    end

    class WrapperTagBuilder
      attr_reader :view_context, :component

      def initialize(view_context, component)
        @view_context = view_context
        @component = component
      end

      def method_missing(name, options = nil, &block)
        component.wrapper_tag(
          (options || {}).merge(html_tag: name),
          &block
        )
      end

      def respond_to_missing?
        true
      end
    end
  end
end
