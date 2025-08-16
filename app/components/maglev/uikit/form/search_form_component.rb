class Maglev::Uikit::Form::SearchFormComponent < Maglev::Uikit::BaseComponent
  attr_reader :name, :value, :search_path, :placeholder

  def initialize(name:, value:, search_path:, placeholder: nil, class_names: nil)
    @name = name
    @value = value
    @search_path = search_path
    @placeholder = placeholder
    @class_names = class_names
  end

  def class_names
    class_variants(
      base: 'inline-flex items-center py-2 px-4 rounded bg-gray-100 text-gray-800 has-[:focus]:ring has-[:focus]:ring-inset has-[:focus]:ring-2 has-[:focus]:ring-editor-primary/50',
    ).render(class: @class_names || '')
  end

  def clear_button_class_names(...)
    class_variants(
      base: 'ml-1 text-gray-500 cursor-pointer',
      variants: {
        invisible: 'invisible',
      }
    ).render(invisible: value.size > 0)
  end
end