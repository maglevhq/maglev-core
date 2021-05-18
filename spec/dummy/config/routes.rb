# frozen_string_literal: true

Rails.application.routes.draw do
  # FIXME: We might want to mount `Maglev::Engine` here
  mount Maglev::Core::Engine => '/maglev'

  get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }
end
