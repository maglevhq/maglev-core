# frozen_string_literal: true

namespace :maglev do
  namespace :tailwindcss do
    desc 'Generate Tailwind CSS classes from component files'
    task build: :environment do
      puts '[Maglev] Building EditorTailwind CSS'
      run_tailwindcss_cli
    end

    desc 'Watch for changes in component files and rebuild Tailwind CSS'
    task watch: :environment do
      run_tailwindcss_cli('--watch')
    end

    # rubocop:disable Metrics/AbcSize
    def run_tailwindcss_cli(options = nil)
      command_path = Maglev::Engine.root.join('exe', 'tailwind-cli')
      Maglev::Engine.root.join('tmp/maglev-compiled-tailwind.css')
      erb_input_path = Maglev::Engine.root.join('app/assets/stylesheets/maglev/tailwind.css.erb')
      input_path = Maglev::Engine.root.join('tmp/maglev-compiled-tailwind.css')
      output_path = Maglev::Engine.root.join('app/assets/builds/maglev/tailwind.css')

      FileUtils.mkdir_p(input_path.dirname)

      puts "[Maglev] Generating temporary Tailwind input file at: #{input_path}"

      rendered_css = ERB.new(File.read(erb_input_path)).result
      File.write(input_path, rendered_css)

      system "#{command_path} -i #{input_path} -o #{output_path} #{options}"
    end
    # rubocop:enable Metrics/AbcSize
  end
end
