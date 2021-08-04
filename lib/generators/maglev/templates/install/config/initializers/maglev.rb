# frozen_string_literal: true

Maglev.configure do |config|
  # Title of the Editor window
  # config.title = 'Maglev - Editor'

  # Logo of the Editor (top left corner).
  # Put your custom logo in the app/assets/images folder of your Rails application.
  # config.logo = 'logo.png'

  # Favicon (window tab)
  # Put your custom favicon in the app/assets/images folder of your Rails application.
  # config.favicon = 'favicon.ico'

  # Primary color of the Editor
  # config.primary_color = '#7E6EDB'

  # Action triggered when clicking on the very bottom left button in the Editor
  # config.back_action = 'https://www.mysite.dev' # External url
  # config.back_action = :my_account_path # name of the route in your Rails application
  # config.back_action = ->(site) { redirect_to main_app.my_account_path(site_id: site.id) }

  # Uploader engine (:active_storage is only supported for now)
  config.uploader = :active_storage
end
