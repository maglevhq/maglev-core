# frozen_string_literal: true

module Maglev
  module Sections
    class ScreenshotsController < ApplicationController
      def create
        # TODO: the screenshot_path depends on the engine flavor
        services.persist_section_screenshot.call(
          screenshot_path: "/theme/#{params[:id]}.png",
          base64_image: params[:screenshot][:base64_image]
        )
        head :created
      end
    end
  end
end
