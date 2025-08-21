require 'class_variants'

class Maglev::Uikit::BaseComponent < ViewComponent::Base
  include ClassVariants::ActionView::Helpers  

  def button_class_names(...)
    helpers.maglev_button_classes(...)
  end
end