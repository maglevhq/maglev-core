import { PageRenderer } from '@hotwired/turbo'

// iFrames will always be reloaded even if we mark them as turbo-permanent. 
// In the context of the Editor, the workaround is to replace the content of another DIV (#root) 
// instead of the body and put the preview iframe as a sibling of the root DIV.
// assignNewBody is the right function to patch because it's called by both the PageRenderer and the SnapshotRenderer.

// Inspirations: 
// - https://github.com/hotwired/turbo/pull/711/files
// - https://github.com/Challenge-Guy/turbo-cfm1/commit/2a3b0acfe0367f32c9d1635ff7c6fd7d87d2a2cd
PageRenderer.prototype.assignNewBody = function() {
  const body = document.querySelector("#root")
  const el   = this.newElement.querySelector("#root")

  // Only update sync elements during snapshot preview render
  // those elements are permanent during the snapshot preview render and updated when we've got the new snapshot
  if (this.isPreview) {
    const syncElements = document.querySelectorAll('[data-turbo-sync]')
    syncElements.forEach(element => {
      const currentElement = document.querySelector(`#${element.id}`)
      const newElement = this.newElement.querySelector(`#${element.id}`)
      
      if (currentElement && newElement) {
        // sync the innerHTML of the newElement with the currentElement
        newElement.innerHTML = currentElement.innerHTML
      }
    })    
  }

  // replace all the data attributes of the BODY tag with the data attributes of the newElement
  // This is because the BODY tag carries the current page id in one of the controller values
  const bodyDataAttributes = document.body.dataset
  const newElementDataAttributes = this.newElement.dataset
  Object.keys(newElementDataAttributes).forEach(key => {
    bodyDataAttributes[key] = newElementDataAttributes[key]
  })

  // now replace the "body" with the newElement
  if (body && el) {
    body.replaceWith(el)
    return
  } else if (document.body && this.newElement instanceof HTMLBodyElement) {
    document.body.replaceWith(this.newElement)
  } else {
    document.documentElement.appendChild(this.newElement)
  }
}