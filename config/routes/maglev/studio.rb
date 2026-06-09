# frozen_string_literal: true

# Studio-only utilities (controllers reject requests outside +Rails.env.local?+).
namespace :studio, path: 'studio' do
  get 'section_preview/:slug', to: 'section_preview#show', as: :section_preview
end
