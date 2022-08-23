# frozen_string_literal: true

require 'vite_rails/version'
require 'vite_rails/tag_helpers'

module Maglev
  module ApplicationHelper
    include ::ViteRails::TagHelpers
    
    # Override: Returns the engine assets manifest.
    def vite_manifest
      ::Maglev::Engine.vite_ruby.manifest
    end
  end
end
