class Maglev::Uikit::Collapsible::CollapsibleComponent < Maglev::Uikit::BaseComponent
  renders_many :items, 'Maglev::Uikit::Collapsible::ItemComponent'
end