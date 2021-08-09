import * as axios from 'axios'
import router from '@/router'
import store from '@/store'
import { debounce } from '@/utils'

let listeners = []
let hoveredSectionId = null

const addEventListener = (target, type, listener, capture) => {
  listeners.push({ target, type, listener })
  target.addEventListener(type, listener, capture)
}

// const removeEventListeners = () => {
//   listeners.forEach(({ target, type, listener }) => {
//     target.removeEventListener(type, listener)
//   })
// }

const getElementType = (el) => {
  return el.dataset.maglevSectionId ? 'section' : 'setting'
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
  let mouseX = 0
  let mouseY = 0

  addEventListener(previewDocument, 'mousemove', (e) => {
    mouseX = e.clientX
    mouseY = e.clientY
  })

  addEventListener(previewDocument, 'scroll', () => {
    const el = previewDocument
      .elementFromPoint(mouseX, mouseY)
      .closest('[data-maglev-section-id]')

    if (!previewDocument.ticking && el) {
      previewDocument.ticking = true
      const event = new CustomEvent('maglev:preview:scroll', {
        detail: { boundingRect: el.getBoundingClientRect() },
      })
      window.dispatchEvent(event)
    }
  })
}

const onSectionHovered = (el) => {
  // console.log('onSectionHovered', el.dataset.maglevSectionId)
  const sectionId = el.dataset.maglevSectionId
  if (hoveredSectionId !== sectionId) {
    store.dispatch('hoverSection', { el, sectionId })
    hoveredSectionId = sectionId
  }
}

const onSectionLeft = () => {
  // console.log('onSectionLeft')
  store.dispatch('leaveSection')
  hoveredSectionId = null
}

const onSettingHovered = (el) => {
  if (!el) return null
  el.style.outline = '2px solid transparent'
  el.style.outlineOffset = '2px'
  el.style.boxShadow = '0 0 0 2px var(--maglev-editor-outline-color)'
  if (!el.style.borderRadius) el.style.borderRadius = '2px'
}

const onSettingLeft = (el) => {
  el.style.boxShadow = 'none'
}

const onSettingClicked = (el, event) => {
  const fragments = el.dataset.maglevId.split('.')
  console.log('select', el.dataset.maglevId, fragments, router)

  event.stopPropagation() & event.preventDefault()

  let route = { params: { settingId: fragments[1] }, hash: '#content' }

  // is it a section or a block setting?
  const isSectionBlock = !!el.closest('[data-maglev-block-id]')

  // console.log(isSectionBlock, el.closest('[data-maglev-block-id]'))

  if (isSectionBlock) {
    route.name = 'editSectionBlockSetting'
    route.params.sectionBlockId = fragments[0]
  } else {
    route.name = 'editSectionSetting'
    route.params.sectionId = fragments[0]
  }

  router.push(route).catch((err) => {
    if (err.name !== 'NavigationDuplicated') throw err
  })
}

const setupEvents = (previewDocument) => {
  // mousescroll
  listenScrolling(previewDocument)

  // mouseenter
  listen(previewDocument, 'mouseenter', (el, type) => {
    switch (type) {
      case 'section':
        return onSectionHovered(el)
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
}

export const setup = (previewDocument) => {
  previewDocument.head.insertAdjacentHTML(
    'beforeend',
    `<style type="text/css">:root { --maglev-editor-outline-color: ${store.state.editorSettings.primaryColor}; }</style>`,
  )
  setupEvents(previewDocument)
}

const updatePreviewDocument = (previewDocument, content, section) => {
  console.log('refreshPreviewDocument', content)

  const attributes = {
    pageSections: JSON.stringify(content.pageSections),
  }

  axios.post(previewDocument.location.href, attributes).then(({ data }) => {
    let parser = new DOMParser()
    const doc = parser.parseFromString(data, 'text/html')

    // NOTE: Instructions to refresh the whole document
    // removeEventListeners()
    // previewDocument.querySelector('body').replaceWith(doc.querySelector('body'))
    // setupEvents(previewDocument)

    const selector = `[data-maglev-section-id='${section.id}']`
    const sourceElement = doc.querySelector(selector)
    let targetElement = previewDocument.querySelector(selector)

    if (!sourceElement)
      throw new Error(
        `Maglev section ${section.id} not generated by the server`,
      )

    if (targetElement) {
      targetElement.replaceWith(sourceElement)
    } else {
      const parentNode = previewDocument.querySelector('[data-maglev-dropzone]')
      parentNode.appendChild(sourceElement)
      targetElement = previewDocument.querySelector(selector)
    }
    targetElement.scrollIntoView(true)
  })
}

const debouncedUpdatePreviewDocument = debounce(updatePreviewDocument, 300)

const updateSectionTextSetting = (previewDocument, section, change) => {
  const selector = `[data-maglev-id='${section.id}.${change.settingId}']`
  const settings = previewDocument.querySelectorAll(selector)

  console.log(
    'updateSectionTextSetting',
    settings,
    settings.length,
    `${section.id}.${change.settingId}`,
  )

  settings.forEach(($el) => {
    $el.innerHTML = change.value
  })

  return settings.length > 0
}

export const updateSectionSetting = (
  previewDocument,
  content,
  section,
  sectionBlock,
  change,
) => {
  console.log('updateSectionSetting', change)

  if (!change) {
    debouncedUpdatePreviewDocument(previewDocument, content, section)
    return
  }

  let source = sectionBlock || section
  let foundSetting = false
  switch (change.settingType) {
    case 'text':
      foundSetting = updateSectionTextSetting(previewDocument, source, change)
      break
    case 'link':
      if (change.settingOptions.withText)
        foundSetting = updateSectionTextSetting(previewDocument, source, {
          ...change,
          value: change.value.text,
          settingId: `${change.settingId}.text`,
        })
      break
    case 'image_picker':
    case 'checkbox':
    case 'color':
      foundSetting = false
      break
    default:
      console.log(
        'inlineEditing.updateSectionSetting',
        'unknown type',
        change.settingType,
      )
      break
  }

  if (!foundSetting)
    debouncedUpdatePreviewDocument(previewDocument, content, section)
}

export const addSection = (previewDocument, content, section) => {
  debouncedUpdatePreviewDocument(previewDocument, content, section)
}

export const removeSection = (previewDocument, sectionId) => {
  const selector = `[data-maglev-section-id='${sectionId}']`
  let element = previewDocument.querySelector(selector)
  element.remove()
}

export const updateMoveSection = (
  previewDocument,
  sectionId,
  targetSectionId,
  direction,
) => {
  console.log('updateMoveSection', sectionId, targetSectionId, direction)

  const sectionElement = previewDocument.querySelector(
    `[data-maglev-section-id='${sectionId}']`,
  )
  const targetSectionElement = previewDocument.querySelector(
    `[data-maglev-section-id='${targetSectionId}']`,
  )

  if (direction === 'up')
    targetSectionElement.parentNode.insertBefore(
      sectionElement,
      targetSectionElement,
    )
  else
    targetSectionElement.parentNode.insertBefore(
      sectionElement,
      targetSectionElement.nextSibling,
    )

  // scroll to the new placement of the section
  sectionElement.scrollIntoView(true)
}
