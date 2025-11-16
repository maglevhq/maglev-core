# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Maglev::Engine.routes.draw do
  # convenient route to create the site in development mode from the Maglev UI
  resource :site, only: %i[create], controller: :site if Rails.env.local?

  # Editor
  namespace :editor do
    root to: 'home#index'

    get 'leave', to: 'home#destroy', as: :leave

    resources :assets, only: %i[index create destroy]
    resources :icons, only: %i[index]
    resource :link, only: %i[edit update]

    # combobox routes
    namespace :combobox do
      resources :pages, only: :index
      resources :collection_items, only: :index
    end

    # always keep the scope of the current page and locale in the url
    scope ':locale/:page_id' do
      root to: 'home#index', as: :real_root

      resources :pages do
        resource :clone, controller: :page_clone, only: :create
      end

      resources :sections do
        put :sort, on: :collection
        resources :blocks, controller: :section_blocks do
          put :sort, on: :collection
        end
      end

      resource :style, controller: :style, only: %i[edit update]

      resource :publication, controller: :publication, only: :create
    end
  end

  root to: 'editor/home#index'

  # Preview
  get 'preview/(*path)', to: 'page_preview#index',
                         defaults: { path: 'index', rendering_mode: :editor },
                         constraints: Maglev::PreviewConstraint.new,
                         as: :site_preview
  post 'preview/(*path)', to: 'page_preview#create', defaults: { path: 'index', rendering_mode: :editor }

  # Public Assets
  get 'assets/:id(/:filename)', to: "#{Maglev.uploader_proxy_controller_name}#show",
                                as: :public_asset
end
# rubocop:enable Metrics/BlockLength
