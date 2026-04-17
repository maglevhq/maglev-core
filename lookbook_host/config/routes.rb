# frozen_string_literal: true

Rails.application.routes.draw do
  # Kamal / kamal-proxy health checks use this path (before Lookbook catches "/").
  # Use `to:` so RuboCop does not rewrite to `get up: '...'` (invalid / ambiguous routing).
  get 'up', to: 'rails/health#show', as: :rails_health_check

  get '/maglev/editor/combobox/pages', to: 'lookbook_combobox_pages#index'

  mount Lookbook::Engine, at: '/'
end
