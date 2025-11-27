# frozen_string_literal: true

pin '@floating-ui/dom', to: '@floating-ui--dom.js'
pin '@floating-ui/core', to: '@floating-ui--core.js'
pin '@floating-ui/utils', to: '@floating-ui--utils.js'
pin '@floating-ui/utils/dom', to: '@floating-ui--utils--dom.js'

pin 'el-transition'
pin '@shopify/draggable', to: '@shopify--draggable.js'
pin 'stimulus-use'

pin '@hotwired/turbo-rails', to: '@hotwired--turbo-rails.js'
pin '@hotwired/turbo', to: '@hotwired--turbo.js'
pin '@rails/actioncable/src', to: '@rails--actioncable--src.js'
pin '@hotwired/stimulus', to: '@hotwired--stimulus.js'
pin '@rails/request.js', to: '@rails--request.js.js'

# check out scripts/tiptap-bundle/README.md for more information
pin 'tiptap', to: 'tiptap.bundle.js'

pin_all_from File.expand_path('../app/components/maglev/uikit', __dir__), under: 'uikit-controllers', to: 'maglev/uikit'
pin_all_from File.expand_path('../app/assets/javascripts/maglev/editor/controllers', __dir__),
             under: 'maglev-controllers',
             to: 'maglev/editor/controllers'
pin_all_from File.expand_path('../app/assets/javascripts/maglev/editor/patches', __dir__),
             under: 'maglev-patches',
             to: 'maglev/editor/patches'

pin 'editor', to: 'maglev/editor/index.js'
