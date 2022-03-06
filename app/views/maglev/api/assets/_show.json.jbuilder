# frozen_string_literal: true

json.id asset.id
json.filename asset.filename
json.byte_size asset.byte_size
json.width asset.width
json.height asset.height
json.url public_asset_url(asset, host: maglev_config.asset_host, only_path: maglev_config.asset_host.blank?)
