# frozen_string_literal: true

get '/sitemap', to: 'maglev/sitemap#index', defaults: { format: 'xml' }

get '(*path)', to: 'maglev/published_page_preview#index', defaults: { path: 'index' },
               constraints: Maglev::PreviewConstraint.new
