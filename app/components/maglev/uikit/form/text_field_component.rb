# frozen_string_literal: true

class Maglev::Uikit::Form::TextFieldComponent < ViewComponent::Base
  attr_reader :label, :name, :options, :html_options

  # options: { value: nil, placeholder: nil, error: nil }
  # html_options: { data: { attribute: 'value' } }
  def initialize(label:, name:, options: {}, html_options: {})
    @label = label
    @name = name
    @options = options
    @html_options = html_options
  end

  def input_html_attributes
    helpers.tag.attributes(
      id: dom_id,
      name: name,
      autocomplete: 'off',
      placeholder: placeholder,
      value: value,
      **html_options
    )
  end

  def dom_id
    name.to_s.parameterize.underscore
  end

  def value
    options[:value]
  end

  def hint
    options[:hint]
  end

  def placeholder
    options[:placeholder]
  end

  def error
    options[:error]
  end
end