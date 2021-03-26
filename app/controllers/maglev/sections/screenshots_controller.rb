# frozen_string_literal: true

module Maglev
  module Sections
    class ScreenshotsController < ApplicationController
      before_action :fetch_site, :fetch_theme, :fetch_section

      def create
        @section.create_screenshot(params[:screenshot][:base64_image])
        # dir = Rails.root.join("public/themes/#{@theme.id}").to_s
        # filepath = File.join(dir, "#{@section.id}.png")
        # FileUtils.mkdir_p(dir)

        # image_data = Base64.decode64(
        #   params[:screenshot][:base64_image]['data:image/png;base64,'.length..-1]
        # )

        # File.open(filepath, 'wb') do |f|
        #   f.write(image_data)
        # end

        head :created
      end

      private

      def fetch_site
        @site = ::Maglev::Site.new(name: 'Maglev Preview site')
      end

      def fetch_theme
        @theme = Maglev::Theme.default
      end

      def fetch_section
        @section = @theme.sections.find(params[:id])
      end
    end
  end
end
