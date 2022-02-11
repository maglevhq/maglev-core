# frozen_string_literal: true

module Maglev
  class PreviewConstraint
    attr_reader :preview_host

    def initialize(preview_host = nil)
      @preview_host = preview_host
    end

    def matches?(request)
      request.format == :html && (!preview_host || preview_host == request.host)
    end
  end
end
