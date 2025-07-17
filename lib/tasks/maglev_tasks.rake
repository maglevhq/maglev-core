# frozen_string_literal: true

$stdout.sync = true

def within_engine_folder(&block)
  Dir.chdir(File.join(__dir__, '..', '..'), &block)
end

unless ENV['VITE_RUBY_SKIP_ASSETS_PRECOMPILE_EXTENSION'] == 'true'
  if Rake::Task.task_defined?('assets:precompile')
    Rake::Task['assets:precompile'].enhance do |_task|
      Rake::Task['maglev:vite:install_dependencies'].invoke
      Rake::Task['maglev:vite:build_all'].invoke
    end
  else
    Rake::Task.define_task("assets:precompile": ['maglev:vite:install_dependencies', 'maglev:vite:build_all'])
  end

  if Rake::Task.task_defined?('assets:clobber')
    Rake::Task['assets:clobber'].enhance do
      Rake::Task['maglev:vite:clobber'].invoke
    end
  else
    Rake::Task.define_task("assets:clobber": 'maglev:vite:clobber')
  end
end
