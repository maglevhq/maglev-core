# frozen_string_literal: true

Maglev::Engine.routes.draw do
  mount Maglev::Core::Engine => '/'

  root to: 'dashboard#index'

  namespace 'sections' do
    resources :preview, controller: 'previews', only: [:show]
    get :preview_in_frame, to: 'previews#iframe_show'
    resources :screenshots, only: [:create]
  end

  get 'editor/(*something)', to: 'editor#show', as: :editor
  get 'preview/(*path)', to: 'page_preview#index', defaults: { path: 'index', preview_mode: true }, as: :site_preview
  post 'preview/(*path)', to: 'page_preview#create', defaults: { path: 'index', preview_mode: true }
end
