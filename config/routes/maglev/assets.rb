# frozen_string_literal: true

get 'assets/:id(/:filename)', to: "#{Maglev.uploader_proxy_controller_name}#show",
                              as: :public_asset
