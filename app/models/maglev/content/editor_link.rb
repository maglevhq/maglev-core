class Maglev::Content::EditorLink
  include ActiveModel::Model
  include ActiveModel::Attributes

  # attr_accessor :link_type, :link_id, :href, :text

  validates :link_type, presence: true
  validates :email_href, presence: true, if: :email_type?
  validates :url_href, presence: true, if: :url_type?

  attribute :link_type, :string
  attribute :link_id, :integer
  attribute :href, :string
  attribute :open_new_window, :boolean, default: false

  %w[email url page].each do |type|
    define_method(:"#{type}_type?") do
      link_type == type
    end

    define_method(:"#{type}_href") do
      (send(:"#{type}_type?") && href).presence || ''
    end

    define_method(:"#{type}_href=") do |value|
      self.href = value
    end

  end

  def persisted?
    true
  end

  def to_component_params
    as_json['attributes'].with_indifferent_access
  end
end