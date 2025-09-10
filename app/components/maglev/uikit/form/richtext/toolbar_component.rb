class Maglev::Uikit::Form::Richtext::ToolbarComponent < ViewComponent::Base
  
  def initialize(line_break: false  )
    @line_break = line_break
  end

  def line_break?
    @line_break
  end
end