class Maglev::Uikit::Form::LinkComponent < Maglev::Uikit::BaseComponent
  attr_reader :name, :path, :options

  # Value: { link_type:, link_id:, href:, text: }
  def initialize(name:, path:, options: {})
    @name = name
    @path = path
    @options = options
  end

  def dom_id
    name.to_s.parameterize.underscore
  end

  def turbo_frame_id
    "#{dom_id}-frame"
  end

  def value
    (options[:value] || {}).with_indifferent_access
  end

  def label
    options[:label]
  end

  def value?
    value&.compact_blank.present?
  end

  def placeholder
    options[:placeholder].presence || t('maglev.editor.form.link.placeholder')
  end

  def error
    options[:error]
  end

  def with_text?
    !!options[:with_text]
  end

  def link_text
    {
      name: "#{name}[text]",
      placeholder: t('maglev.editor.form.link.text_placeholder'),
    }.merge(options[:link_text] || {})
  end

  def link_type_component
    self.class.link_type_component(value: value, path: path.gsub(':id', turbo_frame_id))
  end

  def self.link_type_component(value:, path:)
    klass = link_type_klasses_map.fetch(value[:link_type].to_sym, nil)

    return unless klass

    klass.new(link: value, path: path)
  end

  def self.link_type_klasses_map
    {
      email: Maglev::Uikit::Form::Link::EmailLinkComponent,
      url: Maglev::Uikit::Form::Link::UrlLinkComponent,
      page: Maglev::Uikit::Form::Link::PageLinkComponent,
    }
  end
end