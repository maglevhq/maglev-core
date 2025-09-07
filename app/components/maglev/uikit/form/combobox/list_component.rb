class Maglev::Uikit::Form::Combobox::ListComponent < ViewComponent::Base
  renders_many :options, 'Maglev::Uikit::Form::Combobox::OptionComponent'
end