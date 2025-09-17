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

pin '@tiptap/core', to: 'https://esm.sh/@tiptap/core'
pin '@tiptap/extension-document', to: 'https://esm.sh/@tiptap/extension-document'
pin '@tiptap/extension-text', to: 'https://esm.sh/@tiptap/extension-text'
pin '@tiptap/extension-paragraph', to: 'https://esm.sh/@tiptap/extension-paragraph'
pin '@tiptap/extension-heading', to: 'https://esm.sh/@tiptap/extension-heading'
pin '@tiptap/extension-blockquote', to: 'https://esm.sh/@tiptap/extension-blockquote'
pin '@tiptap/extension-code-block', to: 'https://esm.sh/@tiptap/extension-code-block'
pin '@tiptap/extension-history', to: 'https://esm.sh/@tiptap/extension-history'
pin '@tiptap/extension-bold', to: 'https://esm.sh/@tiptap/extension-bold'
pin '@tiptap/extension-italic', to: 'https://esm.sh/@tiptap/extension-italic'
pin '@tiptap/extension-underline', to: 'https://esm.sh/@tiptap/extension-underline'
pin '@tiptap/extension-strike', to: 'https://esm.sh/@tiptap/extension-strike'
pin '@tiptap/extension-link', to: 'https://esm.sh/@tiptap/extension-link'
pin '@tiptap/extension-list', to: 'https://esm.sh/@tiptap/extension-list'

pin '@tiptap/extension-superscript', to: 'https://esm.sh/@tiptap/extension-superscript'
pin '@tiptap/extension-hard-break', to: 'https://esm.sh/@tiptap/extension-hard-break'

pin_all_from File.expand_path('../app/components/maglev/uikit', __dir__), under: 'uikit-controllers', to: 'maglev/uikit'
pin_all_from File.expand_path('../app/components/maglev/inputs', __dir__), under: 'inputs-controllers',
                                                                           to: 'maglev/inputs'
# pin_all_from File.expand_path('../app/components/maglev/editor/settings', __dir__), under: 'settings-controllers',
#                                                                            to: 'maglev/editor/settings'
pin_all_from File.expand_path('../app/assets/javascripts/maglev/editor/controllers', __dir__),
             under: 'maglev-controllers',
             to: 'maglev/editor/controllers'

pin 'editor', to: 'maglev/editor/index.js'
