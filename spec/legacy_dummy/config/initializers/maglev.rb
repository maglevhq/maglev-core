# frozen_string_literal: true

Maglev.configure do |config|
  config.uploader = :active_storage

  config.collections = {
    products: {
      model: 'Product',
      fields: {
        label: :name,
        image: :thumbnail_url
      }
    }
  }

  config.default_site_locales = [{ label: 'English', prefix: 'en' }, { label: 'French', prefix: 'fr' }]

  config.static_pages = [
    {
      title: { en: 'Products', fr: 'Produits' },
      path: { en: 'products', fr: 'fr/produits' }
    },
    {
      title: { en: 'Authentication', fr: 'Authentification' },
      path: { en: 'sign-in', fr: 'fr/se-connecter' }
    }
  ]

  config.reserved_paths = %w[products sign-in search posts/*]
end
