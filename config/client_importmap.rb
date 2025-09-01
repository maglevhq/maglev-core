# frozen_string_literal: true

pin_all_from File.expand_path('../app/assets/javascripts/maglev/client', __dir__), under: 'maglev-client',
                                                                                   to: 'maglev/client'

pin 'client', to: 'maglev/client/index.js'
