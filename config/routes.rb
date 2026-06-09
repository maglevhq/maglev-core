# frozen_string_literal: true

Maglev::Engine.routes.draw do
  # Editor
  namespace :editor do
    draw 'maglev/editor'
  end

  # Preview
  draw 'maglev/preview'

  # Studio (for local usage)
  draw 'maglev/studio' if Rails.env.local?

  # Public Assets
  draw 'maglev/assets'

  # convenient route to create the site in development mode from the Maglev UI
  resource :site, only: %i[create], controller: :site if Rails.env.local?

  root to: 'editor/home#index'
end
