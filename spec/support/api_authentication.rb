puts "Hello world!!!"

module Maglev
  module SpecHelpers
    module APIAuthentication

      def api_sign_in
        allow(Maglev.config).to receive(:is_authenticated).and_return(->(site) { true })
        get '/maglev/editor'
      end

    end
  end
end