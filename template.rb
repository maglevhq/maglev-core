# frozen_string_literal: true

if Rails.version.start_with?('7.') && RUBY_VERSION.start_with?('2.')
  puts "🚨 We're sorry but Maglev works with Rails 7 and Ruby 3.x.\nPlease install Ruby 3."
  exit
end

gem 'maglevcms', '~> 1.1.1'
gem 'maglevcms-hyperui-kit', '~> 1.1.0'
gem 'image_processing', '~> 1.2'

after_bundle do
  rails_command 'db:create'
  rails_command 'active_storage:install'

  generate 'maglev:install'
  generate 'maglev:hyperui:install', '--force'

  rails_command 'maglev:create_site'
end
