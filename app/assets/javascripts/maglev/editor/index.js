import "@hotwired/turbo-rails"
import "maglev-controllers"
import { PageRenderer, StreamActions } from '@hotwired/turbo'

console.log('Maglev Editor v2 ⚡️')

// This is a hack to prevent the view transition from being triggered when clicking on a link with the same pathname and search
document.addEventListener("click", (event) => {
  const link = event.target.closest("a[href]")
  if (!link) return

  const current = new URL(window.location.href)
  const target  = new URL(link.href, window.location.origin)

  if (current.pathname === target.pathname && current.search === target.search) {
    link.dataset.turboAction = "replace"
  }
})

// iFrames will always be reloaded even if we mark them as turbo-permanent. 
// In the context of the Editor, the workaround is to replace the content of another DIV (#root) 
// instead of the body and put the preview iframe as a sibling of the root DIV.
PageRenderer.prototype.assignNewBody = function() {
  const body = document.querySelector("#root")
  const el   = this.newElement.querySelector("#root")

  if (body && el) {
    body.replaceWith(el)
    return
  } else if (document.body && this.newElement instanceof HTMLBodyElement) {
    document.body.replaceWith(this.newElement)
  } else {
    document.documentElement.appendChild(this.newElement)
  }
}

// Custom stream actions
 
StreamActions.console_log = function() {
  const message = this.getAttribute("message")
  console.log(message)
}