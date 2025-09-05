class Maglev::Uikit::BreadcrumbsComponent < Maglev::Uikit::BaseComponent
  renders_many :breadcrumbs, 'Maglev::Uikit::BreadcrumbsComponent::LinkComponent'
end