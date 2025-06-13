# frozen_string_literal: true

Rails.application.config.after_initialize do
  # Skip in test environment
  # Only check if we're running the server or console
  if !Rails.env.test? && (defined?(Rails::Server) || defined?(Rails::Console))
    site_exists = Maglev::Site.exists?
    store_exists = Maglev::SectionsContentStore.exists?

    if site_exists && !store_exists
      Rails.logger.warn '🚨🚨🚨 Your Maglev site needs to be migrated to V2. Please run: rails maglev:upgrade_from_v1'
    end
  end
end
