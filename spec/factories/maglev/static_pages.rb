# frozen_string_literal: true

FactoryBot.define do
  factory :static_page, class: Maglev::StaticPage do
    id { 'static-page-1' }
    title_translations { { 'en' => 'Products', 'fr' => 'Produits' } }
    path_translations { { 'en' => 'products', 'fr' => 'fr/produits' } }    
  end
end