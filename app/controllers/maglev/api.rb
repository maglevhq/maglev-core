# frozen_string_literal: true

module Maglev
  module API
    autoload :SitesController, File.expand_path('api/sites_controller', __dir__)
    autoload :PagesController, File.expand_path('api/pages_controller', __dir__)
    autoload :PageClonesController, File.expand_path('api/page_clones_controller', __dir__)
    autoload :AssetsController, File.expand_path('api/assets_controller', __dir__)
    autoload :CollectionItemsController, File.expand_path('api/collection_items_controller', __dir__)
  end
end

Maglev::Api = Maglev::API
