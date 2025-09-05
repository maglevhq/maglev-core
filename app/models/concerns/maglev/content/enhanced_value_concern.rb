module Maglev::Content::EnhancedValueConcern

  def label
    @label ||= extract_enhanced_value_if do |setting_definition, value|
      setting_definition.content_label(value)
    end    
  end

  def label?
    label.present?
  end

  def image
    @image ||= extract_enhanced_value_if do |setting_definition, value|
      setting_definition.content_image(value)
    end
  end

  def image?
    image.present?
  end

  private

  def extract_enhanced_value_if
    definition.settings.each do |setting_definition|
      value = settings.value_of(setting_definition.id)
      next if value.blank?

      enhanced_value = yield(setting_definition, value)
      return enhanced_value if enhanced_value.present?
    end
    nil
  end
end