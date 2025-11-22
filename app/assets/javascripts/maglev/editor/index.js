import "@hotwired/turbo-rails"
import "maglev-controllers"
import { PageRenderer, StreamActions } from '@hotwired/turbo'

console.log('Maglev Editor v2 ⚡️')

// We need to set the content locale in the headers for each Turbo request
document.addEventListener("turbo:before-fetch-request", (event) => {
  const { fetchOptions } = event.detail
  const contentLocale = document.querySelector("meta[name=content-locale]").content
  fetchOptions.headers["X-MAGLEV-LOCALE"] = contentLocale
});

// This is a hack to prevent the view transition from being triggered when clicking on a link with the same pathname and search
document.addEventListener("click", (event) => {
  const link = event.target.closest("a[href]")
  if (!link) return

  const current = new URL(window.location.href)
  const target  = new URL(link.href, window.location.origin)

  if (current.pathname === target.pathname && current.search === target.search) {
    console.log('same link clicked!!!')
    link.dataset.turboAction = "replace"
  }
})

const nextEventLoopTick = () => new Promise((resolve) => {
  setTimeout(() => resolve(), 0);
});

// Monkey patch the PageRenderer to use a different root element (other than the body)
// PR: https://github.com/hotwired/turbo/pull/711/files
// Code: https://github.com/Challenge-Guy/turbo-cfm1/commit/2a3b0acfe0367f32c9d1635ff7c6fd7d87d2a2cd

PageRenderer.renderElement = async function(currentElement, newElement) {
  // await nextEventLoopTick()

  console.log('custom renderElement!!!') //, currentElement, newElement)

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

  console.log('newBody', newBody, newBody instanceof HTMLBodyElement)
  
  if (document.body && newBody instanceof HTMLBodyElement) {
    console.log('BODY DETECTED!!!')
    // document.body.replaceWith(newElement)
  } else if (currentBody && newBody instanceof HTMLBodyElement === false) {
    // const currentBody = PageRenderer.getBodyElement(currentElement)
    // const newBody = PageRenderer.getBodyElement(newElement)

    console.log('replaceWith!!!', currentBody, newBody)

    currentBody.replaceWith(newBody)
  } else {
    console.log('appendChild!!!')
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

// iFrames will always be reloaded even if we mark them as turbo-permanent. 
// In the context of the Editor, the workaround is to replace the content of another DIV (#root) 
// instead of the body and put the preview iframe as a sibling of the root DIV.
PageRenderer.prototype.assignNewBody2 = async function() {
  await nextEventLoopTick()

  const body = document.querySelector("#root")
  const el   = this.newElement.querySelector("#root")

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

  // await this.renderElement(this.currentElement, this.newElement)
}

// When the page is rendered, we need to replace the topbar page info with the new one
document.addEventListener("turbo:before-render", (event) => {
  if (event.target.hasAttribute('data-turbo-preview') === true) {
    console.log('cache')
  } else {
    console.log('no cache') //event.target, event.detail.newBody)
    const oldPageInfoFrame = event.target.querySelector('turbo-frame[data-key="topbar-page-info"]')
    const newPageInfoFrame = event.detail.newBody.querySelector('turbo-frame[data-key="topbar-page-info"]')

    // console.log('oldPageInfoFrame', oldPageInfoFrame.dataset, 'newPageInfoFrame', newPageInfoFrame.dataset)

    // if (oldPageInfoFrame && newPageInfoFrame && newPageInfoFrame.children.length > 0) {
    //   // console.log('replacePageInfoFrame', oldPageInfoFrame, newPageInfoFrame.children[0])
    //   // console.log('replacePageInfoFrame', oldPageInfoFrame, newPageInfoFrame)
    //   // oldPageInfoFrame.replaceChildren(newPageInfoFrame.children[0])
    //   // oldPageInfoFrame.replaceWith(newPageInfoFrame)
    //   // oldPageInfoFrame.children[0].innerHTML = 'Hello world!'
    //   // newPageInfoFrame.children[0].innerHTML = 'Hello world!'
    // }

    if (oldPageInfoFrame && newPageInfoFrame) {
      console.log('replacePageInfoFrame') //, oldPageInfoFrame, newPageInfoFrame)
      // oldPageInfoFrame.replaceWith(newPageInfoFrame)
      oldPageInfoFrame.replaceChildren(newPageInfoFrame.children[0])
    }
    // event.detail.render = (currentElement, newElement) => {
    //   console.log('render !!!')
    // }
  }
  

  // // event.detail.render = (currentElement, newElement) => {
  // //   console.log('render', currentElement, newElement)
  // //   if (document.documentElement.hasAttribute("data-turbo-preview"))
  // //     console.log('cache')
  // //   else
  // //     console.log('no cache')
  //   console.log('--------------------------------')
  // // }

  // const newFrame = event.detail.newBody.querySelector('turbo-frame[id="topbar-page-info"]')

  // if (!newFrame) return

  // console.log('newFrame', newFrame?.children[0])

  // const oldFrame = document.body.querySelector('turbo-frame[id="topbar-page-info"]')

  // if (oldFrame && newFrame) {
  //   oldFrame.replaceWith(newFrame)
  // }
  
  // const oldFrame = event.detail.currentBody.querySelector('turbo-frame[id="topbar-page-info"]')

  // if (newFrame && oldFrame) {
  //   oldFrame.replaceWith(newFrame)    
  // }
})

// Custom stream actions
 
StreamActions.console_log = function() {
  const message = this.getAttribute("message")
  console.log(message)
}

StreamActions.dispatch_event = function() {
  const type = this.getAttribute("type")
  const payload = this.getAttribute("payload")
  console.log('dispatchEvent', type, payload, `dispatcher:${type}`)
  const event = new CustomEvent(`dispatcher:${type}`, { detail: JSON.parse(payload) })
  window.dispatchEvent(event)
}