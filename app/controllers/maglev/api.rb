# frozen_string_literal: true

module Maglev
  module API
    autoload :PagesController, File.expand_path('api/pages_controller', __dir__)
    autoload :AssetsController, File.expand_path('api/assets_controller', __dir__)
  end
end

Maglev::Api = Maglev::API
