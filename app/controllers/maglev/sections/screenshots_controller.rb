# frozen_string_literal: true

module Maglev
  module Sections
    class ScreenshotsController < ApplicationController
      def create
        services.persist_section_screenshot.call(
          section_id: params[:id],
          base64_image: params[:screenshot][:base64_image]
        )
        head :created
      end
    end
  end
end
