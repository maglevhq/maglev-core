# frozen_string_literal: true

module Maglev
  class UpgradeFromV1
    include Injectable

    argument :site
    argument :theme

    def call
      ActiveRecord::Base.transaction do
        unsafe_call
      end
    end

    private

    def unsafe_call
      migrate_site_scoped_sections
      migrate_pages
      upgrade_layout_template
    end

    def migrate_site_scoped_sections
      Maglev::SectionsContentStore.create!(
        handle: ::Maglev::SectionsContentStore::SITE_HANDLE,
        sections_translations: site['sections_translations']
      )
    end

    def migrate_pages
      pages.find_each do |page|
        upgrade_page(page)
      end
    end

    def upgrade_page(page)
      create_sections_content_store(page)

      page.update!(layout_id: default_layout.id)
    end

    def create_sections_content_store(page)
      Maglev::SectionsContentStore.create!(
        page: page,
        handle: "#{default_layout_group.id}-#{page.id}",
        sections_translations: page['sections_translations']
      )
    end

    def upgrade_layout_template
      template = load_old_layout_template
                 .gsub('data-maglev-dropzone',
                       "data-maglev-#{default_layout_group.id}-dropzone")
                 .gsub('render_maglev_sections', "render_maglev_group :#{default_layout_group.id} %>")

      persist_layout_template(template, "#{default_layout.id}.html.erb")
    end

    def pages
      Maglev::Page
    end

    def default_layout
      theme.layouts.first
    end

    def default_layout_group
      default_layout.groups.first
    end

    def load_old_layout_template
      File.read(Rails.root.join('app/views/theme/layout.html.erb').to_s)
    end

    def persist_layout_template(template, filename)
      File.write(Rails.root.join("app/views/theme/layouts/#{filename}.html.erb").to_s, template)
    end
  end
end
