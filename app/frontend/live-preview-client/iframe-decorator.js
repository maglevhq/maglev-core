import { postMessage } from './message'
import { debounce, isBlank } from './utils'

// keep track of the current hovered section
let listeners = []
let hoveredSectionId = null

export const start = (config) => {
  const previewDocument = window.document

  // set the primary color
  previewDocument.head.insertAdjacentHTML(
    'beforeend',
    `<style type="text/css">:root { --maglev-editor-outline-color: ${config.primaryColor}; }</style>`,
  )

  // mousescroll
  listenScrolling(previewDocument)

  // mouseenter
  listen(previewDocument, 'mouseenter', (el, type) => {
    switch (type) {
      case 'section':
        return onSectionHovered(previewDocument, el, config.stickySectionIds)
      case 'setting':
        return onSettingHovered(el)
      default:
        break
    }
  })

  // mouseleave
  listen(previewDocument, 'mouseleave', (el, type) => {
    switch (type) {
      case 'section':
        return onSectionLeft(el)
      case 'setting':
        return onSettingLeft(el)
      default:
        break
    }
  })

  // click
  listen(previewDocument, 'click', (el, type, event) => {
    switch (type) {
      case 'setting':
        return onSettingClicked(el, event)
      default:
        break
    }
  })

  // click on links
  disableLinks(previewDocument)

  // Only works on Google Chrome
  selectHoveredSectionAtStartup(previewDocument, config.stickySectionIds)
}

const selectHoveredSectionAtStartup = (previewDocument, stickySectionIds) => {
  setTimeout(() => {
    const section = previewDocument.querySelector('[data-maglev-section-id]:hover')

    if (section) {
      onSectionHovered(previewDocument, section, stickySectionIds, true)
    }
  }, 200)
}

const listen = (previewDocument, eventType, handler) => {
  const capture = eventType === 'mouseenter' || eventType === 'mouseleave'
  addEventListener(
    previewDocument.body,
    eventType,
    (event) => {
      if (event.target === previewDocument) return

      let sectionElement = event.target.closest('[data-maglev-section-id]')
      let settingElement = event.target.closest('[data-maglev-id]')
      let el = settingElement || sectionElement

      // not related to maglev element, no need to continue
      if (!el) return

      if (eventType === 'mouseleave') {
        if (settingElement) {
          if (settingElement != event.target) return
        } else {
          if (sectionElement != event.target) return
          // special case: hovering the section-highlighter component from the parent document
          const rect = sectionElement.getBoundingClientRect()
          const scrollX = previewDocument.defaultView.scrollX
          const scrollY = previewDocument.defaultView.scrollY
          if (
            event.pageX > rect.left + scrollX &&
            event.pageX < rect.right + scrollX &&
            event.pageY > rect.top + scrollY &&
            event.pageY < rect.bottom + scrollY
          )
            return
        }
      }

      handler(el, getElementType(el), event)
    },
    capture,
  )
}

const listenScrolling = (previewDocument) => {
  const scrollNotifier = () => {
    const el = previewDocument.querySelector('[data-maglev-section-id]:hover')
    if (el) postMessage('scroll', { boundingRect: el.getBoundingClientRect() })
  }

  addEventListener(previewDocument, 'scroll', scrollNotifier)
}

const onSectionHovered = (previewDocument, el, stickySectionIds, force = false) => {
  const sectionId = el.dataset.maglevSectionId

  if (hoveredSectionId !== sectionId || force) {
    postMessage('section:hover', {
      sectionId,
      sectionRect: el.getBoundingClientRect(),
      sectionOffsetTop: getMinTop(previewDocument, sectionId, stickySectionIds),
    })
    hoveredSectionId = sectionId
  }
}

const getMinTop = (previewDocument, currentSectionId, stickySectionIds) => {
  for (var i = 0; i < stickySectionIds.length; i++) {
    const sectionId = stickySectionIds[i]
    if (sectionId === currentSectionId) return 0 // hovering a sticky section!

    const selector = `[data-maglev-section-id='${sectionId}']`
    const stickyElement = previewDocument.querySelector(selector)

    if (stickyElement) return stickyElement.offsetHeight // found sticky element found
  }
  return 0
}

const onSectionLeft = () => {
  postMessage('section:leave')
  hoveredSectionId = null
}

const onSettingHovered = (el) => {
  if (!el) return null
  el.style.outline = '2px solid transparent'
  el.style.outlineOffset = '2px'
  el.style.boxShadow = '0 0 0 2px var(--maglev-editor-outline-color)'
  if (
    !el.style.borderRadius &&
    window.getComputedStyle(el).borderRadius === '0px'
  )
    el.style.borderRadius = '2px'
}

const onSettingLeft = (el) => {
  el.style.boxShadow = 'none'
}

const onSettingClicked = (el, event) => {
  event.stopPropagation() & event.preventDefault()

  const fragments = el.dataset.maglevId.split('.')

  // is it a section or a block setting?
  const isSectionBlock = !!el.closest('[data-maglev-block-id]')
  const prefix = isSectionBlock ? 'sectionBlock' : 'section'

  postMessage(`${prefix}:setting:clicked`, {
    [`${prefix}Id`]: fragments[0],
    settingId: fragments[1],
  })
}

const addEventListener = (target, type, listener, capture) => {
  listeners.push({ target, type, listener })
  target.addEventListener(type, listener, capture)
}

const disableLinks = (previewDocument) => {
  addEventListener(previewDocument.body, 'click', (event) => {
    const link = event.target.closest('a')
    if (link && !isBlank(link.href)) {
      event.stopPropagation() & event.preventDefault()
      return false
    }
  })
}

const getElementType = (el) => {
  return el.dataset.maglevSectionId ? 'section' : 'setting'
}
