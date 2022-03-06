# frozen_string_literal: true

require 'uri'

module Maglev
  class PreviewConstraint
    attr_reader :preview_host

    def initialize(preview_host: nil)
      @preview_host = preview_host == true ? default_preview_host : preview_host
    end

    def matches?(request)
      request.format == :html && (!preview_host || preview_host == request.host)
    end

    protected

    def default_preview_host
      return nil if Maglev.config.preview_host.blank?
      URI.parse(Maglev.config.preview_host).host # make sure we get only the host here
    end
  end
end
