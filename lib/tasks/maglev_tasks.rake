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
