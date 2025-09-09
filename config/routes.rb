# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Maglev::Engine.routes.draw do
  # API (only used by the Legacy Editor)
  constraints format: :json do
    namespace :api do
      root to: proc { [200, {}, ['{}']] }
      resource :site, only: :show
      resources :pages do
        resources :clones, controller: :page_clones, only: :create
      end
      resources :assets
      resource :publication, only: %i[show create]
      resources :collection_items, path: 'collections/:collection_id', only: %i[index show]
    end
  end

  root to: redirect { Maglev::Engine.routes.url_helpers.admin_root_path }

  # JS client lib for a headless use of Maglev (TO BE REMOVED)
  get 'live-preview-client.js', to: (redirect(status: 302) do |_, request|
    manifest = ::Maglev::Engine.vite_ruby.manifest
    entries = manifest.resolve_entries(*%w[live-preview-rails-client], type: :javascript)
    [
      request.base_url,
      *entries.fetch(:scripts).flatten.uniq
    ].join
  end), as: :live_preview_client_js

  # Admin (to be refactored)
  namespace :admin do
    root to: 'dashboard#index'
    resource :theme, only: %i[show]
    namespace :sections, path: 'sections/:id' do
      get :preview, to: 'previews#show'
      get :preview_in_frame, to: 'previews#iframe_show'
      resources :screenshots, only: [:create]
    end
  end

  # Editor
  namespace :editor do
    root to: 'home#index'

    get 'leave', to: 'home#destroy', as: :leave

    resources :assets, only: %i[index create destroy]
    resource :link, only: %i[edit update]
    
    # combobox routes
    namespace :combobox do
      resources :pages, only: :index
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
    end
  end

  # Legacy Editor
  get 'legacy-editor', to: 'legacy_editor#show', as: :base_editor
  get 'legacy-editor/:locale/(*path)', to: 'legacy_editor#show', as: :editor
  get 'legacy-leave_editor', to: 'legacy_editor#destroy', as: :leave_editor

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
