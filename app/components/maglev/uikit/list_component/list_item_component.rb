class Maglev::Uikit::ListComponent::ListItemComponent < Maglev::Uikit::BaseComponent
  renders_one :handle
  renders_one :image
  renders_one :pre_title
  renders_one :title  
  renders_one :action

  renders_one :insert_top_button, ->(link:) { Maglev::Uikit::ListComponent::InsertButtonComponent.new(link: link, insert_at: "top") }
  renders_one :insert_bottom_button, ->(link:) { Maglev::Uikit::ListComponent::InsertButtonComponent.new(link: link, insert_at: "bottom") }

  attr_reader :link

  def initialize(id: nil, link:)
    @id = id
    @link = link    
  end

  def id
    @id || SecureRandom.uuid
  end

  def link_url
    link[:url]
  end

  def link_data
    link[:data] || {}
  end

  def image_classes(...)
    class_variants(
      base: 'object-cover w-full h-full'
    ).render(...)
  end
end