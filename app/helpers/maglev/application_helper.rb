# frozen_string_literal: true

require 'webpacker/helper'

module Maglev
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      use_engine_webpacker? ? ::Maglev.webpacker : super
    end
  end
end
