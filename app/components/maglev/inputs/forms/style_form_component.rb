class Maglev::Inputs::Forms::StyleFormComponent < Maglev::Inputs::Forms::DynamicFormComponent

  def initialize(values:, theme:, path:)
    super(
      values: values, 
      definitions: theme.style_settings, 
      path: path, 
      i18n_scope: "maglev.themes.#{theme.id}.style"
    )
  end

  def value_of(definition_id)
    values.value_of(definition_id)
  end

  def input_scope
    'style'
  end
end