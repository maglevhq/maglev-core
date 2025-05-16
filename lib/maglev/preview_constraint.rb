# frozen_string_literal: true

require 'uri'

module Maglev
  class PreviewConstraint
    CRAWLER_USER_AGENTS = /Googlebot|Twitterbot|facebookexternalhit|LinkedInBot/o

    attr_reader :preview_host

    def initialize(preview_host: nil)
      @preview_host = preview_host == true ? default_preview_host : preview_host
    end

    def matches?(request)
      !websocket?(request) && (accepted_format?(request) || crawler?(request)) && match_host?(request)
    end

    protected

    def default_preview_host
      return nil if Maglev.config.preview_host.blank?

      URI.parse(Maglev.config.preview_host).host # make sure we get only the host here
    end

    def accepted_format?(request)
      %i[html xml].include?(request.format.symbol)
    end

    def crawler?(request)
      request.format.symbol.nil? && CRAWLER_USER_AGENTS.match?(request.user_agent)
    end

    def websocket?(request)
      request.headers['HTTP_UPGRADE'] == 'websocket'
    end

    def match_host?(request)
      !preview_host || preview_host == request.host
    end
  end
end
