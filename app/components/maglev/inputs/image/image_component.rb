class Maglev::Inputs::Image::ImageComponent < Maglev::Inputs::InputBaseComponent

  def initialize(setting:, value:, scope:)
    super
    @value = value&.with_indifferent_access
  end

  # required by the ImageLibrary when selecting an image
  def image_source
    input_names[:url].parameterize.underscore
  end

  def input_names
    %w(id url alt_text width height byte_size).each_with_object({}) do |key, hash|
      hash[key.to_sym] = "#{input_name}[#{key}]"
    end    
  end
end