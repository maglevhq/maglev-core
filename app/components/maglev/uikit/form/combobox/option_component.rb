class Maglev::Uikit::Form::Combobox::OptionComponent < ViewComponent::Base
  attr_reader :id, :label

  def initialize(id:, label:)
    @id = id
    @label = label 
  end

  def to_args
    { id:, label: }
  end
end