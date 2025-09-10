class Maglev::Uikit::Form::RichtextComponent < ViewComponent::Base
  attr_reader :label, :name, :options, :html_options

  def initialize(label:, name:, options: {}, html_options: {})
    @label = label
    @name = name
    @options = options
    @html_options = html_options || {}
  end

  def dom_id
    name.to_s.parameterize.underscore
  end

  def value
    options[:value]
  end

  def number_of_rows
    options[:rows] || 4
  end

  def line_break?
    options[:line_break] || false
  end

  def edit_link_path
    options[:edit_link_path]
  end

  def placeholder
    options[:placeholder]
  end

  def label_name
    options[:label_name]
  end

  def error
    options[:error]
  end

  def build_data_action(actions)
    [html_options.dig(:data, :action), actions].compact.join(' ')
  end
end