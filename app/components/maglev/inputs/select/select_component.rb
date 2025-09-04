class Maglev::Inputs::Select::SelectComponent < Maglev::Inputs::InputBaseComponent

  def choices
    (setting.options[:select_options] || []).map do |option|
      option_label, option_value = extra_option_label_and_value(option)

      [translate_choice(option_value, default: option_label), option_value]
    end
  end

  def extra_option_label_and_value(option)
    option.is_a?(Hash) ? option.values_at(:label, :value) : [option, option]
  end

  def translate_choice(choice, default: nil)
    ::I18n.t("#{i18n_scope}.settings.#{setting.id}_options.#{choice}", default: default)
  end
end