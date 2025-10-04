# frozen_string_literal: true

if Rake::Task.task_defined?('assets:precompile')
  Rake::Task['assets:precompile'].enhance do |_task|
    Rake::Task['maglev:tailwindcss:build'].invoke
  end
else
  Rake::Task.define_task("assets:precompile": ['maglev:tailwindcss:build'])
end
