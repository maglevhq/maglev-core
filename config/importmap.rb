pin "@floating-ui/dom", to: "@floating-ui--dom.js"
pin "@floating-ui/core", to: "@floating-ui--core.js"
pin "@floating-ui/utils", to: "@floating-ui--utils.js"
pin "@floating-ui/utils/dom", to: "@floating-ui--utils--dom.js"

pin "el-transition"
pin "@shopify/draggable", to: "@shopify--draggable.js"
pin "stimulus-use"

pin "@hotwired/turbo-rails", to: "@hotwired--turbo-rails.js" 
pin "@hotwired/turbo", to: "@hotwired--turbo.js"
pin "@rails/actioncable/src", to: "@rails--actioncable--src.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js"
pin "@rails/request.js", to: "@rails--request.js.js"

pin_all_from File.expand_path("../app/components", __dir__), under: "uikit-controllers", to: ""
pin_all_from File.expand_path("../app/assets/javascripts/maglev/controllers", __dir__), under: "maglev-controllers", to: "maglev/controllers"

pin "editor", to: "maglev/editor.js"

