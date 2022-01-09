# frozen_string_literal: true

module Maglev
  class InstallGenerator < Rails::Generators::Base
    desc 'Install Maglev engine'
    source_root File.expand_path('templates/install', __dir__)
    hook_for :maglev_install

    def setup_webpacker
      rake 'webpacker:install'
      rake 'maglev:webpacker:compile'
    end

    def migrations
      rake 'maglev:install:migrations'
      rake 'db:migrate'
    end

    def create_initializer
      directory 'config'
      directory 'public'
    end

    def generate_theme
      generate 'maglev:theme'
    end

    def generate_section
      generate 'maglev:section', 'Dummy'
    end

    def mount_engine
      inject_into_file 'config/routes.rb', before: /^end/ do
        <<-CODE
  mount Maglev::Engine => '/maglev'
  get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }, constraints: Maglev::PreviewConstraint.new
        CODE
      end
    end

    def instructions
      $stdout.puts <<~INFO
        Done! 🚅
        You can now tweak /config/initializers/maglev.rb.
        You can also modify your theme (in /app/theme and /app/views/theme)
        and generate new sections with rails g maglev:section.
        The next step is to create a site using `rails maglev:create_site`.
        You'll want to to this last step in production as well!
      INFO
    end
  end
end
