# frozen_string_literal: true

Rails.application.routes.draw do
  # FIXME: We might want to mount `Maglev::Engine` here
  mount Maglev::Engine, as: :maglev, at: '/maglev'

  get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }
end
