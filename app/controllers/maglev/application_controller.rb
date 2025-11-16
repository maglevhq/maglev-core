# frozen_string_literal: true

module Maglev
  class ApplicationController < ::ApplicationController
    include Maglev::ServicesConcern
    include Maglev::ResourceIdConcern
    include Maglev::ErrorsConcern

    protect_from_forgery with: :exception

    helper_method :services
  end
end
