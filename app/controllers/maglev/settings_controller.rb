module Maglev
  class SettingsController < ApplicationController

    layout :nil

    def index
      pp helpers.send(:sources_from_manifest_entrypoints, %w(live-preview-client), type: :javascript).first
    end

  end
end