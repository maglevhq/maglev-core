# frozen_string_literal: true

get 'preview/(*path)', to: 'page_preview#index',
                       defaults: { path: 'index', rendering_mode: :editor },
                       constraints: Maglev::PreviewConstraint.new,
                       as: :site_preview

post 'preview/(*path)', to: 'page_preview#create', defaults: { path: 'index', rendering_mode: :editor }
