# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'maglev/version'

# rubocop:disable Metrics/BlockLength
# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'maglevcms'
  spec.version     = Maglev::VERSION
  spec.authors     = ['Didier Lafforgue']
  spec.email       = ['contact@maglev.dev']
  spec.homepage    = 'https://www.maglev.dev/'
  spec.summary     = 'Website/page builder Ruby on Rails engine'
  spec.description = <<-DOC
  MaglevCMS integrates a powerful website/page builder with a polished UX/UI into your Ruby on Rails application, backed by a flexible and robust CMS engine.
  DOC
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'

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
    '.yarnrc.yml',
    '{.yarn,app,config,db,lib}/**/*',
    'bin/vite',
    'package.json',
    'yarn.lock',
    'postcss.config.cjs',
    'tailwind.config.js',
    'vite.config.ts',
    'MIT-LICENSE',
    'Rakefile',
    'README.md'
  ]

  spec.add_dependency 'jbuilder', '< 3', '>= 2'
  spec.add_dependency 'kaminari', '~> 1.2.1'
  spec.add_dependency 'maglev-injectable', '~> 2.1.1'
  spec.add_dependency 'rails', '< 9', '>= 7'
  spec.add_dependency 'vite_rails', '< 4', '>= 3'
  spec.add_dependency 'vite_ruby', '>= 3.5'
end
# rubocop:enable Metrics/BlockLength
