# frozen_string_literal: true

pin '@floating-ui/dom', to: 'maglev/@floating-ui--dom.js'
pin '@floating-ui/core', to: 'maglev/@floating-ui--core.js'
pin '@floating-ui/utils', to: 'maglev/@floating-ui--utils.js'
pin '@floating-ui/utils/dom', to: 'maglev/@floating-ui--utils--dom.js'

pin 'el-transition', to: 'maglev/el-transition.js'
pin '@shopify/draggable', to: 'maglev/@shopify--draggable.js'
pin 'stimulus-use', to: 'maglev/stimulus-use.js'

pin '@hotwired/turbo-rails', to: 'maglev/@hotwired--turbo-rails.js'
pin '@hotwired/turbo', to: 'maglev/@hotwired--turbo.js'
pin '@rails/actioncable/src', to: 'maglev/@rails--actioncable--src.js'
pin '@hotwired/stimulus', to: 'maglev/@hotwired--stimulus.js'
pin '@rails/request.js', to: 'maglev/@rails--request.js.js'

# check out scripts/tiptap-bundle/README.md for more information
pin 'tiptap', to: 'maglev/tiptap.bundle.js'

pin_all_from File.expand_path('../app/components/maglev/uikit', __dir__), under: 'uikit-controllers', to: 'maglev/uikit'
pin_all_from File.expand_path('../app/assets/javascripts/maglev/editor/controllers', __dir__),
             under: 'maglev-controllers',
             to: 'maglev/editor/controllers'
pin_all_from File.expand_path('../app/assets/javascripts/maglev/editor/patches', __dir__),
             under: 'maglev-patches',
             to: 'maglev/editor/patches'

pin 'editor', to: 'maglev/editor/index.js'
