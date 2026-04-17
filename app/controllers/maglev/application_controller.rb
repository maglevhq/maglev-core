# frozen_string_literal: true

module Maglev
  class ApplicationController < Maglev.parent_controller_class
    include Maglev::ServicesConcern
    include Maglev::ResourceIdConcern
    include Maglev::ErrorsConcern

    protect_from_forgery with: :exception

    helper_method :services
  end
end
