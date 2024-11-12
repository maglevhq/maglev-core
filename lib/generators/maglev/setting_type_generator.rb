# frozen_string_literal: true

module Maglev
  class SettingTypeGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/setting_type', __dir__)

    class_option :plugin, type: :string, default: nil

    def plugin_name
      (@plugin_name ||= options[:plugin]).tap do
        if @plugin_name.blank?
          puts '🚨 You need to pass the id of a Maglev plugin' 
          exit 0
        end
      end
    end

    def component_name
      @component_name ||= table_name.dasherize
    end

    def generate
      directory 'packages'
    end

    def register_setting_type_in_ruby
      inject_into_file "packages/#{plugin_name}/lib/#{plugin_name}/engine.rb", before: /  end\n^end/ do
        <<-RUBY
    config.to_prepare do
      Maglev.register_setting_type(id: :#{table_name})
    end

        RUBY
      end
    end

    def register_setting_type_in_javascript
      prepend_to_file "packages/#{plugin_name}/index.js" do
        <<-JAVASCRIPT
import { registerInput } from '@/misc/dynamic-inputs'
import UIKit#{class_name}Input from './app/frontend/editor/components/kit/#{table_name}-input.vue'
        JAVASCRIPT
      end

      inject_into_file "packages/#{plugin_name}/index.js", before: /^}/ do
        <<-JAVASCRIPT
  registerInput('#{table_name}', UIKit#{class_name}Input, (props, _options) => props)
        JAVASCRIPT
      end
    end

    private

    def pluralize_table_names?
      false
    end
  end
end
