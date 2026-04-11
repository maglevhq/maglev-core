# frozen_string_literal: true

Rails.application.routes.draw do
  # Kamal / kamal-proxy health checks use this path (before Lookbook catches "/").
  get "up" => "rails/health#show", as: :rails_health_check

  get "/maglev/editor/combobox/pages", to: "lookbook_combobox_pages#index"

  mount Lookbook::Engine, at: "/"
end
