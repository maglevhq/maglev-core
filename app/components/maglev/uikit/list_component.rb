class Maglev::Uikit::ListComponent < Maglev::Uikit::BaseComponent 
  renders_many :items, types: {
    content: Maglev::Uikit::ListComponent::ListItemComponent,
    insert_button: Maglev::Uikit::ListComponent::InsertButtonComponent
  }

  attr_reader :sort_path
  
  def initialize(sort_path: nil)
    @sort_path = sort_path
  end

  def sortable?
    sort_path.present?
  end
end