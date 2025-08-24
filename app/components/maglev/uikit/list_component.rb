class Maglev::Uikit::ListComponent < Maglev::Uikit::BaseComponent 
  renders_many :items, Maglev::Uikit::ListComponent::ListItemComponent
  
  # def initialize
  # end
end