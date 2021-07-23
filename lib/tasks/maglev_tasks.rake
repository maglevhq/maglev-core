# frozen_string_literal: true

namespace :maglev do
  desc 'Create site'
  task create_site: :environment do
    Maglev::GenerateSite.call(
      theme: Maglev.local_themes.first
    )
  end

  namespace :webpacker do
    desc 'Install deps with yarn'
    task yarn_install: :environment do
      Dir.chdir(File.join(__dir__, '..', '..')) do
        system 'yarn install --no-progress --production'
      end
    end

    desc 'Compile JavaScript packs using webpack for production with digests'
    task compile: %i[yarn_install environment] do
      Webpacker.with_node_env('production') do
        if Maglev.webpacker.commands.compile
          # Successful compilation!
        else
          # Failed compilation
          exit!
        end
      end
    end
  end
end
