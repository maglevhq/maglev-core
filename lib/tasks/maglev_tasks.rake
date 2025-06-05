# frozen_string_literal: true

$stdout.sync = true

def within_engine_folder(&block)
  Dir.chdir(File.join(__dir__, '..', '..'), &block)
end

# Load all task files only if they haven't been loaded before
Dir[File.join(__dir__, 'maglev', '*.rake')].each do |file|
  # Create a unique task loaded flag
  task_name = File.basename(file, '.rake')
  next if Rake::Task.task_defined?("maglev:#{task_name}:loaded")

  load file
  # Create a dummy task to mark this file as loaded
  Rake::Task.define_task("maglev:#{task_name}:loaded")
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
