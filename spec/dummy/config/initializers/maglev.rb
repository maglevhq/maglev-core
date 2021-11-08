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
end
