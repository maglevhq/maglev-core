# frozen_string_literal: true

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
