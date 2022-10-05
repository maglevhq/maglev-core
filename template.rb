# frozen_string_literal: true

# Maglev works only with the following combinations:
# - Rails 6 and Ruby 2.7
# - Rails 7 and Ruby 3+

if Rails.version.start_with?('6.') && RUBY_VERSION.start_with?('3.')
  puts "🚨 We're sorry but Maglev works with Rails 6 and Ruby 2.7.x.\nPlease either upgrade Rails to the version 7 or use Ruby 2.7."
  exit
end

if Rails.version.start_with?('7.') && RUBY_VERSION.start_with?('2.')
  puts "🚨 We're sorry but Maglev works with Rails 7 and Ruby 3.x.\nPlease install Ruby 3."
  exit
end

gem 'maglevcms', '~> 1.0.0.rc2'
gem 'maglevcms-hyperui-kit', '~> 1.0.1'
gem 'image_processing', '~> 1.2'

after_bundle do
  rails_command 'db:create'
  rails_command 'active_storage:install'

  generate 'maglev:install'
  generate 'maglev:hyperui:install', '--force'

  rails_command 'maglev:create_site'
end
