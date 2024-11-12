# frozen_string_literal: true

module Maglev
  class Plugins
    def initialize
      @plugins = {}
    end

    def empty?
      @plugins.empty?
    end

    def size
      @plugins.size
    end

    def find(id)
      @plugins[id.to_sym]
    end

    def each(&block)
      @plugins.values.each(&block)
    end

    def map(&block)
      @plugins.values.map(&block)
    end

    def register(id:, root_path:, name: nil, version: nil)
      raise_if_already_registered_error!(id)
      @plugins[id.to_sym] = Instance.new(id:, name:, root_path:, version:)
    end

    def install!
      each(&:install!)
    end

    def uninstall!
      each(&:uninstall!)
    end

    def single_uninstall!(id)
      raise_if_unknown_error!(id)
      find(id).uninstall!
    end

    private

    def raise_if_already_registered_error!(id)
      return if find(id).nil?

      raise PluginAlreadyRegisteredError, "The #{id} Maglev plugin has been already registered."
    end

    def raise_if_unknown_error!(id)
      return unless find(id).nil?

      raise UnknownPluginError.new, "There is no #{id} registered Maglev plugin."
    end

    class Instance
      attr_reader :id, :name, :root_path, :version

      def initialize(id:, root_path:, name: nil, version: nil)
        @id = id
        @name = name || id
        @root_path = root_path
        @version = version
      end

      def install!
        return false if already_installed?

        Rails.logger.info "[Maglev] 😎 Installing the \"#{name}\" plugin (id: #{id})"

        # the package.json of the engine now will have access
        # to the JS code of the plugin
        File.symlink(root_path, yarn_workspace_path)

        write_frontend_setup_file

        true
      end

      def uninstall!
        return false unless already_installed?

        Rails.logger.info "[Maglev] 👋 Un-installing the \"#{name}\" plugin (id: #{id})"

        File.unlink(yarn_workspace_path)
        File.delete(frontend_plugin_path)

        true
      end

      def already_installed?
        File.symlink?(yarn_workspace_path)
      end

      private

      def write_frontend_setup_file
        # Run the setup function of the plugin when the Editor UI starts
        File.open(frontend_plugin_path, 'w+') do |f|
          f.write(
            <<-JAVASCRIPT
  import setup from "#{id}.js"
  setup()
            JAVASCRIPT
          )
        end
      end

      def frontend_plugin_path
        engine_path.join('app', 'frontend', 'editor', 'plugins', "#{id}.js")
      end

      def yarn_workspace_path
        engine_path.join('plugins', id)
      end

      def engine_path
        Maglev::Engine.root
      end
    end

    class UnknownPluginError < StandardError; end
    class PluginAlreadyRegisteredError < StandardError; end
  end
end
