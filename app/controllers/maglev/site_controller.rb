# frozen_string_literal: true

module Maglev
  class SiteController < Maglev::ApplicationController
    def create
      redirect_to editor_root_path and return if Maglev::Site.exists? || !Rails.env.local?

      Maglev::GenerateSite.call(
        theme: Maglev.local_themes.first
      )

      redirect_to editor_root_path
    end
  end
end
