# frozen_string_literal: true

namespace :maglev do
  namespace :vite do
    desc 'Bundle frontend entrypoints using ViteRuby'
    task build: :'vite:verify_install' do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.build_from_task
      end
    end

    desc 'Bundle entrypoints using Vite Ruby (SSR only if enabled)'
    task build_all: :'vite:verify_install' do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.build_from_task
        Maglev::Engine.vite_ruby.commands.build_from_task('--ssr') if ViteRuby.config.ssr_build_enabled
      end
    end

    desc 'Ensure build dependencies like Vite are installed before bundling'
    task install_dependencies: :environment do
      within_engine_folder do
        install_dev_dependencies = ENV['VITE_RUBY_SKIP_INSTALL_DEV_DEPENDENCIES'] == 'true'
        # rubocop:disable Style/StringHashKeys
        install_env_args = install_dev_dependencies ? {} : { 'NODE_ENV' => 'development' }
        # rubocop:enable Style/StringHashKeys
        cmd = Maglev::Engine.vite_ruby.commands.legacy_npm_version? ? 'npx ci --yes' : 'npx --yes ci'
        result = system(install_env_args, cmd)
        # Fallback to `yarn` if `npx` is not available.
        system(install_env_args, 'yarn install --frozen-lockfile') if result.nil?
      end
    end

    desc 'Verify if ViteRuby is properly installed in the app'
    task verify_install: :environment do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.verify_install
      end
    end

    desc 'Remove old bundles created by ViteRuby'
    task :clean, %i[keep age] => :'vite:verify_install' do |_, args|
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.clean_from_task(args)
      end
    end

    desc 'Remove the build output directory for ViteRuby'
    task clobber: :'vite:verify_install' do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.clobber
      end
    end

    desc "Provide information on ViteRuby's environment"
    task info: :environment do
      within_engine_folder do
        Maglev::Engine.vite_ruby.commands.print_info
      end
    end
  end
end
