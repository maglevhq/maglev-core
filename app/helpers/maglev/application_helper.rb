# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Maglev
  module ApplicationHelper
    def turbo_stream
      # we don't want to pollute the global Turbo::Streams::TagBuilder
      Maglev::Turbo::Streams::TagBuilder.new(self)
    end

    def maglev_editor_javascript_tags
      maglev_importmap_tags(:editor, 'editor')
    end

    def maglev_client_javascript_tags
      return '' unless maglev_rendering_mode == :editor

      maglev_importmap_tags(:client, 'maglev-client')
    end

    def maglev_importmap_tags(namespace, entry_point)
      safe_join [
        javascript_inline_importmap_tag(Maglev::Engine.importmaps[namespace].to_json(resolver: self)),
        javascript_importmap_module_preload_tags(Maglev::Engine.importmaps[namespace]),
        javascript_import_module_tag(entry_point)
      ], "\n"
    end

    def maglev_editor_title
      case maglev_config.title
      when nil
        'Maglev - EDITOR'
      when String
        maglev_config.title
      when Proc
        instance_exec(maglev_site, &maglev_config.title)
      end
    end

    def maglev_editor_logo_url
      case maglev_config.logo
      when nil
        asset_path('maglev/logo.svg')
      when String
        asset_path(maglev_config.logo)
      when Proc
        instance_exec(maglev_site, &maglev_config.logo)
      end
    end

    def maglev_favicon_url
      case maglev_config.favicon
      when nil
        asset_path('maglev/favicon.svg')
      when String
        asset_path(maglev_config.favicon)
      when Proc
        instance_exec(maglev_site, &maglev_config.favicon)
      end
    end

    def maglev_primary_hex_color
      color = maglev_config.primary_color
      if color =~ /^\#(\d)(\d)(\d)$/
        r_value = ''.rjust(2, Regexp.last_match(1))
        g_value = ''.rjust(2, Regexp.last_match(2))
        b_value = ''.rjust(2, Regexp.last_match(3))
        "##{r_value}#{g_value}#{b_value}"
      else
        color
      end
    end

    def maglev_primary_rgb_color
      maglev_primary_hex_color
        .gsub('#', '')
        .scan(/.{2}/)
        .map { |value| value.to_i(16) }
    end

    # UI helpers

    def maglev_button_label(label, options = {})
      options = (options || {}).with_indifferent_access

      render 'maglev/editor/shared/button_label', label: label,
                                                  pending_label: options[:pending] || label,
                                                  success_label: options[:success] || label,
                                                  error_label: options[:error] || label
    end

    # rubocop:disable Metrics/MethodLength
    def maglev_button_classes(...)
      ClassVariants.build(
        base: %(
        rounded-xs transition-colors transition-background duration-200 text-center cursor-pointer
        group-[.is-success]/form:bg-green-500/95 group-[.is-success]/form:hover:bg-green-500/100
        group-[.is-success]/form:disabled:bg-green-500/75
        group-[.is-error]/form:bg-red-500/95 group-[.is-error]/form:hover:bg-red-500/100
        group-[.is-error]/form:disabled:bg-red-500/75
        ),
        variants: {
          color: {
            primary: 'text-white bg-editor-primary/95 hover:bg-editor-primary/100 disabled:bg-editor-primary/75',
            secondary: 'text-gray-800 hover:bg-gray-100'
          },
          size: {
            big: 'flex items-center justify-center w-full px-6 py-4',
            medium: 'inline-flex items-center justify-center px-4 py-2'
          }
        },
        defaults: {
          color: :primary,
          size: :medium
        }
      ).render(...)
    end
    # rubocop:enable Metrics/MethodLength

    def maglev_icon_button_classes(...)
      ClassVariants.build(
        base: %(h-7 w-7 flex items-center justify-center rounded-full focus:outline-none
        transition-colors duration-200 cursor-pointer bg-gray-600/0 text-gray-800
        hover:bg-gray-600/10 hover:text-gray-900)
      ).render(...)
    end

    def maglev_flash_message
      message, color, icon_name = if flash[:notice].present?
                                    [flash[:notice], :green, 'checkbox_circle']
                                  elsif flash[:alert].present?
                                    [flash[:alert], :red, 'error_warning']
                                  end

      return '' if message.blank?

      render Maglev::Uikit::BadgeComponent.new(color: color,
                                               icon_name: icon_name,
                                               disappear_after: 3.seconds).with_content(message)
    end

    def maglev_page_icon(page, size: '1.15rem', wrapper_class_names: nil)
      icon_name = page.index? ? 'home' : 'file'
      content_tag :span, class: class_names('shrink-0 relative', wrapper_class_names) do
        concat(content_tag(:span, '', class: 'absolute -bottom-0.25 right-0 bg-yellow-600 rounded-full w-1.5 h-1.5')) if page.need_to_be_published?
        concat render(Maglev::Uikit::IconComponent.new(name: icon_name, size: size))  
      end
    end

    def maglev_page_preview_reload_data
      {
        controller: 'dispatcher',
        action: 'click->dispatcher#trigger',
        dispatcher_event_name_value: 'page-preview:reload'
      }
    end

    def maglev_live_preview_client_javascript_tag
      # rubocop:disable Layout/LineLength
      Rails.logger.warn '🚨 maglev_live_preview_client_javascript_tag is deprecated, use maglev_client_javascript_tags instead'
      # rubocop:enable Layout/LineLength
      maglev_client_javascript_tags
    end
  end
end
# rubocop:enable Metrics/ModuleLength
