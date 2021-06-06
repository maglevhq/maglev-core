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

  # Admin
  root to: 'dashboard#index'
  namespace 'sections' do
    resources :preview, controller: 'previews', only: [:show]
    get :preview_in_frame, to: 'previews#iframe_show'
    resources :screenshots, only: [:create]
  end

  # Editor
  get 'editor/(*something)', to: 'editor#show', as: :editor
  get 'preview/(*path)', to: 'page_preview#index', defaults: { path: 'index', preview_mode: true }, as: :site_preview
  post 'preview/(*path)', to: 'page_preview#create', defaults: { path: 'index', preview_mode: true }

  # Asset
  get 'assets/:id(/:filename)', to: 'assets#show', as: 'public_asset'
end
