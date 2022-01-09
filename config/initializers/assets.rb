# frozen_string_literal: true

require 'webpacker'
require 'webpacker/helper'

module Webpacker
  module DynamicTag
    def javascript_pack_tag(*names, **options)
      return super unless options[:webpacker]

      new_helper = dup
      new_helper.define_singleton_method(:current_webpacker_instance) do
        if options[:webpacker] == :root
          ::Webpacker.instance
        else
          options[:webpacker].constantize.webpacker
        end
      end
      new_helper.javascript_pack_tag(*names, **options.except(:webpacker))
    end
  end
end

Webpacker::Helper.prepend Webpacker::DynamicTag
