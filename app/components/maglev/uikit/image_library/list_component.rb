# frozen_string_literal: true

module Maglev
  module Uikit
    module ImageLibrary
      class ListComponent < Maglev::Uikit::BaseComponent
        renders_many :images, 'Maglev::Uikit::ImageLibrary::CardComponent'
      end
    end
  end
end
