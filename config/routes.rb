# frozen_string_literal: true

Maglev::Engine.routes.draw do
  root to: 'dashboard#index'

  constraints format: :json do
    namespace 'api' do
      resources :pages
      resources :assets
    end
  end

  namespace 'sections' do
    resources :preview, controller: 'previews', only: [:show]
    resources :screenshots, only: [:create]
    get :preview_in_frame, to: 'previews#iframe_show'
  end

  get 'assets/:id(/:filename)', to: 'assets#show', as: 'public_asset'
  get 'editor/(*something)', to: 'editor#show', as: :editor
  get 'preview/(*path)', to: 'page_preview#index', defaults: { path: 'index' }, as: :site_preview
  post 'preview/(*path)', to: 'page_preview#create', defaults: { path: 'index' }
end
