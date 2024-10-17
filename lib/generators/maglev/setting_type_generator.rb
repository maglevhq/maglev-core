# frozen_string_literal: true

module Maglev
  class SettingTypeGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/setting_type', __dir__)

    class_option :plugin, type: :string, default: nil

    def plugin_name
      (@plugin_name ||= options[:plugin]).tap do
        raise 'Missing plugin option' if @plugin_name.blank?
      end
    end

    def component_name
      @component_name ||= table_name.dasherize
    end

    def generate
      directory 'packages'
    end

    def register_setting_type_in_ruby
      inject_into_file "packages/#{options[:plugin]}/lib/#{options[:plugin]}/engine.rb", before: /  end\n^end/ do
        <<-RUBY
    config.to_prepare do
      Maglev.register_setting_type(id: :#{table_name})
    end
        RUBY
      end
    end

    def register_setting_type_in_javascript
      raise 'TODO'
    end

    private

    def pluralize_table_names?
      false
    end
  end
end
