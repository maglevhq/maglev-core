# frozen_string_literal: true

module Maglev
  module SpecHelpers
    module ApiAuthentication
      def api_sign_in
        allow(Maglev.config).to receive(:is_authenticated).and_return(->(_site) { true })
        get '/maglev/editor'
      end
    end
  end
end
