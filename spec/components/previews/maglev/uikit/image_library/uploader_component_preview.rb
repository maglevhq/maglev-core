# frozen_string_literal: true

module Maglev
  module Uikit
    module ImageLibrary
      class UploaderComponentPreview < ViewComponent::Preview
        def default
          render Maglev::Uikit::ImageLibrary::UploaderComponent.new(
            create_path: 'http://localhost:3001/maglev/editor/assets',
            refresh_path: 'http://localhost:3001/maglev/editor/assets'
          )
        end
      end
    end
  end
end
