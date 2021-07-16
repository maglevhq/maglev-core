# frozen_string_literal: true

Maglev.configure do |c|
  # Title of the Editor window
  # c.title = 'Maglev - Editor'

  # Logo of the Editor (top left corner).
  # Put your custom logo in the app/assets/images folder of your Rails application.
  # c.logo = 'logo.png'

  # Favicon (window tab)
  # Put your custom favicon in the app/assets/images folder of your Rails application.
  # c.favicon = 'favicon.ico'

  # Primary color of the Editor
  # c.primary_color = '#7E6EDB'

  # Action triggered when clicking on the very bottom left button in the Editor
  # c.back_action = 'https://www.myapp.fr' # External url
  # c.back_action = :my_account_path # name of the route in your Rails application
  # c.back_action = ->(site) { redirect_to main_app.my_account_path(site_id: site.id) }

  # Uploader engine (:active_storage is only supported for now)
  # c.uploader = :active_storage
end
