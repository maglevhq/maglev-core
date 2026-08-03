# frozen_string_literal: true

Rails.application.config.after_initialize do
  # Skip in test environment
  # Only check if we're running the server or console
  next if Rails.env.test? || (defined?(Rails::Server).nil? && defined?(Rails::Console).nil?)

  theme = Maglev.local_themes.first
  if theme.layouts.blank?
    # rubocop:disable Rails/Exit
    abort(
      <<~ERROR.strip
        🚨 Your Maglev theme has no layouts.

        Please run:#{' '}

        > rails g maglev:layout default --groups "main*"

        to upgrade your theme to the latest version.

      ERROR
    )
    # rubocop:enable Rails/Exit
  end

  page = Maglev::Page.first
  if page && page.layout_id.blank?
    # rubocop:disable Rails/Exit
    abort(
      <<~ERROR.strip
        🚨 Your Maglev pages have no layout. You need to set the default one for each page.

        Please run:#{' '}

        > rails maglev:upgrade_to_v4

      ERROR
    )
    # rubocop:enable Rails/Exit
  end
end
