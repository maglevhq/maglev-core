# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Maglev::Engine.routes.draw do
  # API
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

  # JS client lib for a headless use of Maglev
  get 'live-preview-client.js', to: (redirect(status: 302) do |_, request|
    manifest = ::Maglev::Engine.vite_ruby.manifest
    entries = manifest.resolve_entries(*%w[live-preview-rails-client], type: :javascript)
    [
      request.base_url,
      *entries.fetch(:scripts).flatten.uniq
    ].join
  end), as: :live_preview_client_js

  # Admin
  namespace :admin do
    root to: 'dashboard#index'
    resource :theme, only: %i[show]
    namespace :sections, path: 'sections/:id' do
      get :preview, to: 'previews#show'
      get :preview_in_frame, to: 'previews#iframe_show'
      resources :screenshots, only: [:create]
    end
  end

  # Editor + Preview
  get 'editor', to: 'editor#show', as: :base_editor
  get 'editor/:locale/(*path)', to: 'editor#show', as: :editor
  get 'leave_editor', to: 'editor#destroy', as: :leave_editor
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
