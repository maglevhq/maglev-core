# frozen_string_literal: true

module Maglev
  class InstallGenerator < Rails::Generators::Base
    desc 'Install Maglev engine'
    source_root File.expand_path('templates/install', __dir__)

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
    end

    def generate_theme
      generate 'maglev:theme'
    end

    def mount_engine
      inject_into_file 'config/routes.rb', before: /^end/ do
        <<-CODE
  mount Maglev::Engine => '/maglev'
  get '(*path)', to: 'maglev/page_preview#index', defaults: { path: 'index' }
        CODE
      end
    end

    def generate_site
      name = ask('Please provide a name for your Maglev site:')
      Maglev::Site.generate!(name: name.presence || 'default')
    end
  end
end
