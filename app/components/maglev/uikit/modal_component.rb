class Maglev::Uikit::ModalComponent < Maglev::Uikit::BaseComponent
  renders_one :title
  renders_one :footer

  attr_reader :id, :open, :focus 
  
  def initialize(id:, open: false, focus: true)
    @id = id
    @open = open
    @focus = focus
  end
end