# frozen_string_literal: true

Maglev::Engine.routes.draw do
  # API
  constraints format: :json do
    namespace 'api' do
      resource :site, only: :show
      resources :pages do
        resources :clones, controller: :page_clones, only: :create
      end
      resources :assets
    end
  end

  root to: redirect { Maglev::Engine.routes.url_helpers.admin_root_path }

  # Admin
  namespace :admin do
    root to: 'dashboard#index'
    resource :theme, only: %i[index show]
    namespace :sections, path: 'sections/:id' do
      get :preview, to: 'previews#show'
      get :preview_in_frame, to: 'previews#iframe_show'
      resources :screenshots, only: [:create]
    end
  end

  # Editor
  get 'editor/(*something)', to: 'editor#show', as: :editor
  get 'preview/(*path)', to: 'page_preview#index', defaults: { path: 'index', rendering_mode: :editor },
                         as: :site_preview
  post 'preview/(*path)', to: 'page_preview#create', defaults: { path: 'index', rendering_mode: :editor }

  # Asset
  get 'assets/:id(/:filename)', to: 'assets#show', as: 'public_asset'
end
