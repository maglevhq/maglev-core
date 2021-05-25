# frozen_string_literal: true

module Maglev
  class GetBaseUrl
    include Injectable

    dependency :controller
    dependency :fetch_site
    
    def call
      preview_mode? ? site_preview_path : nil
    end

    private

    def preview_mode?
      puts ["fetch_site", fetch_site].inspect
      puts ["controller", controller].inspect
      controller.preview_mode?
    end

    def site_preview_path
      controller.site_preview_path
    end
  end
end