# frozen_string_literal: true

module Maglev
  class SectionComponent < BaseComponent
    include TagHelper

    extend Forwardable
    def_delegators :parent, :site, :page, :config

    attr_reader :parent, :id, :type, :settings, :attributes, :definition, :templates_root_path, :rendering_mode

    # rubocop:disable Lint/MissingSuper
    def initialize(parent:, attributes:, definition:, templates_root_path:, rendering_mode:)
      @parent = parent # aka a PageComponent
      @id = attributes[:id]
      @type = attributes[:type]
      @definition = definition
      @attributes = attributes
      @templates_root_path = templates_root_path
      @rendering_mode = rendering_mode

      @settings = settings_proxy(
        build_settings_map(attributes[:settings])
      )
    end
    # rubocop:enable Lint/MissingSuper

    def dom_id
      "section-#{id}"
    end

    # rubocop:disable Rails/OutputSafety
    def dom_data
      "data-maglev-section-id=\"#{id}\" data-maglev-section-type=\"#{type}\"".html_safe
    end
    # rubocop:enable Rails/OutputSafety

    def tag_data
      { maglev_section_id: id, maglev_section_type: type }
    end

    def blocks
      return @blocks if @blocks

      @blocks = if definition.blocks_presentation == 'tree'
                  build_block_tree
                else
                  build_block_list
                end
    end

    def render
      html = super(
        template: "#{templates_root_path}/sections/#{definition.category}/#{type}",
        locals: { section: self, maglev_section: self }
      )
      return html if type == 'spacer'

      begin
        spacing = maglev_extract_spacing
        return html if spacing.nil?

        style_block = maglev_build_spacing_style(spacing)
        maglev_inject_style_into_section(html, style_block)
      rescue StandardError => e
        Rails.logger.error("[Maglev spacing patch] #{e.class}: #{e.message}")
        html
      end
    rescue StandardError => e
      handle_error(e)
    end

    private

    def build_block_list
      build_blocks(attributes[:blocks])
    end

    def build_block_tree(parent_id = nil)
      blocks = attributes[:blocks].select do |block_attributes|
        block_attributes[:parent_id] == parent_id
      end

      build_blocks(blocks) do |block|
        block.children = build_block_tree(block.id)
      end
    end

    def build_blocks(blocks)
      (blocks || []).map do |block_attributes|
        block_definition = definition.blocks.find { |settings| settings.type == block_attributes[:type] }
        next unless block_definition

        block = build_block(block_definition, block_attributes)

        yield block if block_given?

        block
      end.compact
    end

    def build_block(block_definition, block_attributes)
      build(
        BlockComponent,
        section: self,
        definition: block_definition,
        attributes: block_attributes
      )
    end

    def maglev_extract_spacing
      return nil unless settings.respond_to?(:spacing_top) || settings.respond_to?(:spacing_bottom)

      top = Maglev::SettingValue.checkbox_truthy?(maglev_setting_value(:spacing_top))
      bottom = Maglev::SettingValue.checkbox_truthy?(maglev_setting_value(:spacing_bottom))
      return nil unless top || bottom

      size = Maglev::SettingValue.select_string(maglev_setting_value(:spacing_size)) || 'md'

      {
        top: top,
        bottom: bottom,
        mobile_px: Maglev::Spacing.mobile_px_for(size),
        desktop_px: Maglev::Spacing.desktop_px_for(size)
      }
    end

    def maglev_setting_value(key)
      return nil unless settings.respond_to?(key)

      settings.public_send(key)
    end

    def maglev_build_spacing_style(spacing)
      selector = %([data-maglev-section-id="#{id}"])
      mobile_rules = []
      mobile_rules << "padding-top:#{spacing[:mobile_px]}px !important;" if spacing[:top]
      mobile_rules << "padding-bottom:#{spacing[:mobile_px]}px !important;" if spacing[:bottom]
      desktop_rules = []
      desktop_rules << "padding-top:#{spacing[:desktop_px]}px !important;" if spacing[:top]
      desktop_rules << "padding-bottom:#{spacing[:desktop_px]}px !important;" if spacing[:bottom]

      <<~HTML
        <style type="text/css" data-maglev-section-spacing="#{id}">#{selector}{#{mobile_rules.join}}@media(min-width:#{Maglev::Spacing::BREAKPOINT}){#{selector}{#{desktop_rules.join}}}</style>
      HTML
    end

    def maglev_inject_style_into_section(html, style_block)
      pattern = /(<[a-zA-Z][a-zA-Z0-9]*\b[^>]*?data-maglev-section-id=["']#{Regexp.escape(id.to_s)}["'][^>]*>)/
      updated = html.to_s.sub(pattern) { |match| "#{match}#{style_block}" }
      updated.html_safe
    end

    def handle_error(exception)
      raise exception if %i[live section].include?(rendering_mode) || Rails.env.test?

      Rails.logger.error [
        "⚠️  [Maglev] Error when rendering a \"#{type}\" type section ⚠️",
        exception.message,
        *exception.backtrace
      ].join($INPUT_RECORD_SEPARATOR)

      render_error
    end

    def render_error
      <<~HTML
        <div #{dom_data} style="padding: 5rem 0;">
          <div style="max-width: 40rem; margin: 0 auto; background-color: rgb(254 242 242); color: rgb(153 27 27); padding: 1rem; border-radius: 0.375rem;">
            <h3 style="font-weight: 500; color: rgb(153 27 27); font-size: 0.875rem; line-height: 1.25rem;">
              We've encountered an error while rendering the <strong>"#{type}"</strong> section.
            </h3>
            <p style="margin-top: 0.5rem; font-size: 0.775rem; line-height: 1.25rem; color: rgb(185 28 28);">
              Check out your application logs for more details.
            </p>
          </div>
        </div>
      HTML
    end

    def inspect_fields
      %w[id site_id type].map { |field| [field, send(field)] }
    end
  end
end
