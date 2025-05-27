# frozen_string_literal: true

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Maglev'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'vite_ruby'
ViteRuby.install_tasks
ViteRuby.config.root # Ensure the engine is set as the root.

rakefile_path = !defined?(Rails) || Rails::VERSION::MAJOR >= 8 ? 'spec/dummy/Rakefile' : 'spec/legacy_dummy/Rakefile'
APP_RAKEFILE = File.expand_path(rakefile_path, __dir__)

load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'
