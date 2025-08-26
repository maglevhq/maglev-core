# frozen_string_literal: true

namespace :maglev do
  namespace :tailwindcss do
    desc 'Generate Tailwind CSS classes from component files'
    task build: :environment do
      command_path = Maglev::Engine.root.join('exe', 'tailwind-cli')
      input_path = Maglev::Engine.root.join('app/assets/stylesheets/maglev/tailwind.css')
      output_path = Maglev::Engine.root.join('app/assets/builds/maglev/tailwind.css')

      system "#{command_path} -i #{input_path} -o #{output_path}"
    end

    desc 'Watch for changes in component files and rebuild Tailwind CSS'
    task watch: :environment do
      command_path = Maglev::Engine.root.join('exe', 'tailwind-cli')
      input_path = Maglev::Engine.root.join('app/assets/stylesheets/maglev/tailwind.css')
      output_path = Maglev::Engine.root.join('app/assets/builds/maglev/tailwind.css')

      system "#{command_path} -i #{input_path} -o #{output_path} --watch"
    end
  end
end
