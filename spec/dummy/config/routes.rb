# frozen_string_literal: true

Rails.application.routes.draw do
  mount Maglev::Engine => '/maglev'

  get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }
end
