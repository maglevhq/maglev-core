# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'maglev/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'maglev'
  spec.version     = Maglev::VERSION
  spec.authors     = ['Didier Lafforgue']
  spec.email       = ['didier@nocoffee.fr']
  spec.homepage    = 'https://www.nocoffee.fr'
  spec.summary     = 'Embed a multi sites page builder in your Ruby on Rails app'
  spec.description = <<-DOC
  Maglev adds a fancy page builder inside your Ruby on Rails application. This gem comes with a simple but solid CMS engine.'
  DOC
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'injectable', '~> 2.1.1'
  spec.add_dependency 'jbuilder', '~>  2.11.2'
  spec.add_dependency 'kaminari', '~> 1.2.1'
  spec.add_dependency 'rails', '<= 7.1', '>= 6.1.4.4'
  spec.add_dependency 'webpacker', '~> 5.1'

  spec.add_development_dependency 'pg', '~> 1.2.1'
end
