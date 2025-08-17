class Maglev::FormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    attributes = field_attributes(method)

    @template.render(Maglev::Uikit::Form::TextFieldComponent.new(
      label: options[:label].presence || attributes[:content],
      name: attributes[:name],
      value: object.public_send(method),
      placeholder: options[:placeholder],
      error: error_messages(method)
    ))
  end

  def check_box(method, options = {})
    attributes = field_attributes(method)

    @template.render(Maglev::Uikit::Form::CheckboxComponent.new(
      label: options[:label].presence || attributes[:content],
      name: attributes[:name],
      checked: object.public_send(method),
      placeholder: options[:placeholder]
    ))
  end

  def textarea(method, options = {})
    attributes = field_attributes(method)

    @template.render(Maglev::Uikit::Form::TextareaComponent.new(
      label: options[:label].presence || attributes[:content],
      name: attributes[:name],
      value: object.public_send(method),
      rows: options[:rows],
      max_length: options[:max_length]
    ))
  end

  def image_field(method, options = {})
    attributes = field_attributes(method)

    search_path = options[:search_path].is_a?(Proc) ? options[:search_path].call({
      picker: true,
      source: attributes[:name].to_s.parameterize.underscore # same as the dom id of the field
    }) : options[:search_path]

    @template.render(Maglev::Uikit::Form::ImageFieldComponent.new(
      label: options[:label].presence || attributes[:content],
      name: attributes[:name],
      value: object.public_send(method),
      alt_text: options[:alt_text],
      search_path: search_path
    ))
  end

  private

  def field_attributes(method)
    ActionView::Helpers::Tags::Label.new(@object_name, method, @template, nil, objectify_options({})).complete_attributes
  end

  def error_messages(method)
    if object.errors.any?
      object.errors.messages_for(method).join(', ')
    end
  end

  class ActionView::Helpers::Tags::Label
    def complete_attributes
      options = @options.stringify_keys
      tag_value = options.delete("value")
      name_and_id = options.dup

      if name_and_id["for"]
        name_and_id["id"] = name_and_id["for"]
      else
        name_and_id.delete("id")
      end

      add_default_name_and_id_for_value(tag_value, name_and_id)
      options.delete("index")
      options.delete("namespace")
      options["for"] = name_and_id["id"] unless options.key?("for")

      builder = LabelBuilder.new(@template_object, @object_name, @method_name, @object, tag_value)

      content = render_component(builder)

      { content: content }.merge(name_and_id.symbolize_keys)
    end
  end
end
