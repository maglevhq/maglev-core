# frozen_string_literal: true

namespace :maglev do
  desc 'Create site'
  task create_site: :environment do
    Maglev::GenerateSite.call
  end
end
