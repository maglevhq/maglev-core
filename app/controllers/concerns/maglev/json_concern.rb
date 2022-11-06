# frozen_string_literal: true

require 'active_support/concern'

module Maglev
  module JsonConcern
    extend ActiveSupport::Concern

    included do
      before_action :underscore_params!
    end

    protected

    def underscore_params!
      params.instance_variable_get(:@parameters).deep_transform_keys!(&:underscore)
    end
  end
end
