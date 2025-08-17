# frozen_string_literal: true

module Maglev
  class FetchSectionScreenshotPath
    include Injectable

    dependency :fetch_sections_path
    argument :theme, default: nil
    argument :section
    argument :absolute, default: false

    def call
      path = "#{fetch_sections_path.call(theme: theme)}/#{section.category}/#{section.id}.jpg"
      
      if absolute
        Rails.root.join("public/#{path}").to_s
      else
        # For section screenshot/preview images, check if we should use asset_host
        # This fixes the Maglev editor preview images when static serving is disabled
        asset_host = Rails.application.config.asset_host || 
                    Rails.application.config.action_controller.asset_host
        
        if asset_host.present?
          # If asset_host is a proc, evaluate it with lazy evaluation
          if asset_host.respond_to?(:call)
            request_stub = OpenStruct.new(ssl?: Rails.env.production?, host: 'example.com')
            host = asset_host.call(path, request_stub)
          else
            host = asset_host
          end
          
          if host.present?
            # Ensure host doesn't end with slash and build full URL
            "#{host.chomp('/')}/#{path}"
          else
            "/#{path}"
          end
        else
          "/#{path}"
        end
      end
    end
  end
end
