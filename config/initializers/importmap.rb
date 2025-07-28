::Maglev::Engine.importmap.draw do
  pin "editor", to: "maglev/editor.js"
  pin "@hotwired/turbo-rails", to: "turbo.min.js"
  pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
end