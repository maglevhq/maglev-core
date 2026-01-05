# frozen_string_literal: true

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
    member do
      post :clone, controller: 'pages/clone', action: :create
      post :discard_draft, controller: 'pages/discard_draft', action: :create
    end
  end

  scope ':store_id' do
    resources :sections, only: %i[new create] do
      put :sort, on: :collection
    end

    resources :mirrored_sections, only: %i[new create show destroy]
  end

  get 'sections', to: 'sections_stores#index', as: :sections_stores

  resources :sections, only: %i[edit update destroy] do
    resources :blocks, controller: :section_blocks do
      put :sort, on: :collection
    end
  end

  resource :style, controller: :style, only: %i[edit update]

  resource :publication, controller: :publication, only: :create
end
