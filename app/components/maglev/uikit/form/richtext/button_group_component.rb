class Maglev::Uikit::Form::Richtext::ButtonGroupComponent < ViewComponent::Base
  renders_many :buttons, 'Maglev::Uikit::Form::Richtext::ButtonComponent'
end