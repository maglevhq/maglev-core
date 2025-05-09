# frozen_string_literal: true

module Maglev
  class LayoutGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates/layout', __dir__)

    class_option :groups, type: :array, default: ['main'], desc: 'Layout group IDs (e.g., header main* footer)'

    attr_reader :layout_name, :layout_groups

    def set_layout_name
      @layout_name = file_name.underscore
      @layout_groups = options['groups'].map do |group_id|
        OpenStruct.new(
          id: group_id.gsub('*', ''),
          label: group_id.gsub('*', '').humanize,
          store: group_id.end_with?('*') ? 'page' : nil
        )
      end
    end

    def verify_theme_exists
      raise Thor::Error, set_color('ERROR: You must first create a theme.', :red) if theme.nil?
    end

    def create_layout_files
      directory 'app'
    end

    def update_theme_yml
      inject_into_file 'app/theme/theme.yml', before: '# [LAYOUTS] DO NOT REMOVE THIS LINE' do
        ERB.new(erb_template, trim_mode: '-').result(binding)
      end
    end

    private

    def theme
      Maglev.local_themes&.first
    end

    def erb_template
      # rubocop:disable Layout/HeredocIndentation
      <<~ERB
- name: <%= layout_name %>
  groups:
  <%- layout_groups.each do |group| -%>
  - id: <%= group.id %>
    label: "<%= group.label %>"
    <%- if group.store -%>
    store: <%= group.store %>
    <%- else -%>
    # store: <%= group.id %>
    <%- end -%>
    # accept: []
    # recoverable: []
    # mirror_section: false
  <%- end -%>
      ERB
      # rubocop:enable Layout/HeredocIndentation
    end
  end
end
