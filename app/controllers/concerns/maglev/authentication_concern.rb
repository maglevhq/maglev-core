# frozen_string_literal: true

module Maglev
  module AuthenticationConcern
    extend ActiveSupport::Concern

    included do
      before_action :require_authentication
    end

    private

    def require_authentication
      raise Maglev::Errors::NotAuthorized unless authenticated_in_app?

      session[:maglev_site_id] = maglev_site.id
    end

    def authenticated_in_app?
      case maglev_config.is_authenticated
      when nil
        # NOTE: this use case must not happen
        raise 'The Maglev configuration requires the is_authenticated setting. Please read the documentation.'
      when Symbol
        send(maglev_config.is_authenticated, maglev_site)
      when Proc
        instance_exec(maglev_site, &maglev_config.is_authenticated)
      end
    end
  end
end
