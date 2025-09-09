class Maglev::Content::EditorLink
  include ActiveModel::Model
  include ActiveModel::Attributes

  validates :link_type, presence: true
  validates :email, presence: true, if: :email_type?
  validates :href, presence: true, if: :url_type?

  attribute :link_label, :string, default: nil
  attribute :link_type, :string
  attribute :link_id, :string, default: nil
  attribute :section_id, :string, default: nil
  attribute :href, :string
  attribute :email, :string
  attribute :open_new_window, :boolean, default: false

  %w[email url page static_page].each do |type|
    define_method(:"#{type}_type?") do
      link_type == type
    end
  end

  def url_href
    (url_type? && href).presence || ''
  end

  def url_href=(new_value)
    self.href = new_value
  end

  def email=(new_value)
    self.href = "mailto:#{new_value}"
    super
  end

  def persisted?
    true
  end

  def to_component_params
    as_json['attributes'].with_indifferent_access
  end
end