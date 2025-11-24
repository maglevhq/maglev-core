import { PageRenderer } from '@hotwired/turbo'

// Monkey patch the PageRenderer to use a different root element (other than the body)
// PR: https://github.com/hotwired/turbo/pull/711/files
// Code: https://github.com/Challenge-Guy/turbo-cfm1/commit/2a3b0acfe0367f32c9d1635ff7c6fd7d87d2a2cd

// iFrames will always be reloaded even if we mark them as turbo-permanent. 
// In the context of the Editor, the workaround is to replace the content of another DIV (#root) 
// instead of the body and put the preview iframe as a sibling of the root DIV.

PageRenderer.renderElement = async function(currentElement, newElement) {
  // replace all the data attributes of the BODY tag with the data attributes of the newElement
  // This is because the BODY tag carries the current page id in one of the controller values
  const oldBodyAttributes = currentElement.dataset
  const newBodyDataAttributes = newElement.dataset
  Object.keys(newBodyDataAttributes).forEach(key => {
    oldBodyAttributes[key] = newBodyDataAttributes[key]
  })

  // get the root body element (not necessary the same as the document.body)
  const currentBody = PageRenderer.getBodyElement(currentElement)
  const newBody = PageRenderer.getBodyElement(newElement)

  if (document.body && newBody instanceof HTMLBodyElement) {
    // it should never happen
    // document.body.replaceWith(newElement)
    console.warn('[PageRenderer] BODY DETECTED')
  } else if (currentBody && newBody instanceof HTMLBodyElement === false) {
    currentBody.replaceWith(newBody)
  } else {
    document.documentElement.appendChild(newElement)
  }
}

Object.defineProperty(PageRenderer.prototype, "shouldRender", {
  get() {
    return this.newSnapshot.isVisitable && this.trackedElementsAreIdentical && this.bodyElementMatches
  }
})

Object.defineProperty(PageRenderer.prototype, "bodyElementMatches", {
  get() {
    return PageRenderer.getBodyElement(this.newElement) !== null
  }
})

Object.defineProperty(PageRenderer, "bodySelector", {
  get() {
    const bodyId = document.querySelector('meta[name="turbo-body"]').content

    return bodyId ? `#${bodyId}` : 'body'
  }
})

PageRenderer.getBodyElement = function(element) {
  return element.querySelector(PageRenderer.bodySelector) || element
}