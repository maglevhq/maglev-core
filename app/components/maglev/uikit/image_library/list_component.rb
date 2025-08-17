class Maglev::Uikit::ImageLibrary::ListComponent < Maglev::Uikit::BaseComponent
  renders_many :images, 'Maglev::Uikit::ImageLibrary::CardComponent'
end