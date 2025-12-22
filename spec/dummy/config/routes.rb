# frozen_string_literal: true

Rails.application.routes.draw do
  mount Maglev::Engine, as: :maglev, at: '/maglev'

  mount Lookbook::Engine, at: '/lookbook'

  # for testing purpose
  get '/simple-assets/:id', to: 'maglev/assets/proxy#show'

  direct :cdn_image do |model, options|
    if model.respond_to?(:signed_id)
      route_for(
        :rails_service_blob_proxy,
        model.signed_id,
        model.filename,
        options.merge(host: ENV['CDN_HOST'] || 'http://localhost:3000')
      )
    else
      signed_blob_id = model.blob.signed_id
      variation_key  = model.variation.key
      filename       = model.blob.filename

      route_for(
        :rails_blob_representation_proxy,
        signed_blob_id,
        variation_key,
        filename,
        options.merge(host: ENV['CDN_HOST'] || 'http://localhost:3000')
      )
    end
  end

  resources :products, only: [:show]

  get '/nocoffee_site', to: redirect('https://www.nocoffee.fr'), as: :nocoffee

  draw 'maglev/public_preview'
end
