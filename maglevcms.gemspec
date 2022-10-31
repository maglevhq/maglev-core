# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'maglev/version'

# Describe your gem and declare its dependencies:
# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name        = 'maglevcms'
  spec.version     = Maglev::VERSION
  spec.authors     = ['Didier Lafforgue']
  spec.email       = ['contact@maglev.dev']
  spec.homepage    = 'https://www.maglev.dev/'
  spec.summary     = 'Page builder Ruby on Rails'
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

  spec.files = Dir[
    '.babelrc',
    '.eslintrc.js',
    '{app,config,db,lib}/**/*',
    'bin/webpack',
    'bin/webpack-dev-server',
    'package.json',
    'yarn.lock',
    'postcss.config.js',
    'tailwind.config.js',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  spec.add_dependency 'jbuilder', '~>  2.11.2'
  spec.add_dependency 'kaminari', '~> 1.2.1'
  spec.add_dependency 'maglev-injectable', '~> 2.1.1'
  spec.add_dependency 'rails', '<= 7.1', '>= 6'
  spec.add_dependency 'vite_rails', '<= 4', '>= 3'

  spec.add_development_dependency 'pg', '~> 1.4.3'
end
# rubocop:enable Metrics/BlockLength
