# frozen_string_literal: true

require 'webpacker/helper'

module Maglev
  module ApplicationHelper
    include ::Webpacker::Helper

    def current_webpacker_instance
      ::Maglev.webpacker
    end
  end
end
