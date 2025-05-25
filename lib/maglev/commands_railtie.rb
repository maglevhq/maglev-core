# frozen_string_literal: true

module Maglev
  class CommandsRailtie < Rails::Railtie
    railtie_name :maglev_commands

    initializer 'maglev.commands' do
      require 'rails/command'

      # Require all command files
      Dir[File.expand_path('../commands/**/*_command.rb', __dir__)].sort.each do |file|
        require file
      end
    end
  end
end
