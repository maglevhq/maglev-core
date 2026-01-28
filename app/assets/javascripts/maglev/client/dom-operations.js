import { debounce, postMessageToEditor } from 'maglev-client/utils'
import runScripts from 'maglev-client/run-scripts'

const parentDocument = window.parent.document
const previewDocument = window.document
const csrfParam =
  window.location !== window.parent.location
    ? {
        [parentDocument
          .querySelector("meta[name='csrf-param']")
          .getAttribute('content')]: parentDocument
          .querySelector("meta[name='csrf-token']")
          .getAttribute('content'),
      }
    : {}

export const start = () => {
  // Within a Rails site, no need to remove the event listeners
  window.addEventListener('maglev:section:add', addSection)
  window.addEventListener('maglev:section:move', moveSections)
  window.addEventListener('maglev:section:update', updateSection)
  window.addEventListener('maglev:section:remove', removeSection)
  window.addEventListener('maglev:section:checkLockVersion', checkSectionLockVersion)
  window.addEventListener('maglev:section:ping', pingSection)
  window.addEventListener('maglev:block:add', replaceSection)
  window.addEventListener('maglev:block:move', replaceSection)
  window.addEventListener('maglev:block:remove', replaceSection)
  window.addEventListener('maglev:block:ping', pingSectionBlock)
  window.addEventListener('maglev:setting:update', updateSetting)

  window.addEventListener('maglev:style:update', updateStyle)
}

// === Section related actions ===

const addSection = (event) => {
  const { layoutStoreId, sectionId, insertAt } = event.detail
  debouncedUpdatePreviewDocument({ layoutStoreId, sectionId, insertAt, scrollToSection: true })
}

const moveSections = (event) => {
  const { oldIndex, newIndex } = event.detail

  const direction = oldIndex < newIndex ? 'down' : 'up'

  const sectionElement = previewDocument.querySelector(
    `[data-maglev-section-id]:nth-child(${oldIndex + 1})`,
  )
  const targetSectionElement = previewDocument.querySelector(
    `[data-maglev-section-id]:nth-child(${newIndex + 1})`,
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
  scrollToSectionOrBlock(sectionElement)
}

const updateSection = (event) => {
  const { sectionId } = event.detail
  debouncedUpdatePreviewDocument({ sectionId })
}

const removeSection = (event) => {
  const { sectionId } = event.detail
  const selector = `[data-maglev-section-id='${sectionId}']`
  const element = previewDocument.querySelector(selector)
  element.remove()
  postMessageToEditor('section:removed', { numberOfSections: previewDocument.querySelectorAll('[data-maglev-section-id]').length })
}

const checkSectionLockVersion = (event) => {
  const { sectionId, lockVersion } = event.detail
  console.log('[DOM Operations] checkSectionLockVersion', event)
  const section = previewDocument.querySelector(`[data-maglev-section-id='${sectionId}']`)
  const localLockVersion = section?.getAttribute('data-maglev-section-lock-version')
  if (lockVersion !== localLockVersion && lockVersion !== '') {
    debouncedUpdatePreviewDocument({ sectionId })
  }
}

const pingSection = (event) => {
  const { sectionId } = event.detail
  const selector = `[data-maglev-section-id='${sectionId}']`
  const sectionElement = previewDocument.querySelector(selector)
  if (sectionElement) {
    scrollToSectionOrBlock(sectionElement)
  }
}

// === Block related actions ===

const replaceSection = (event) => {
  const { sectionId } = event.detail
  debouncedUpdatePreviewDocument({ sectionId })
}

const pingSectionBlock = (event) => {
  const { sectionBlockId } = event.detail
  const selector = `[data-maglev-block-id='${sectionBlockId}']`
  const blockElement = previewDocument.querySelector(selector)
  if (blockElement) {
    scrollToSectionOrBlock(blockElement)
  }
}

// === Other actions ===

const updateSetting = (event) => {
  const { sectionId, sourceId, change } = event.detail

  let foundSetting = false
  
  switch (change.settingType) {
    case 'text':
      foundSetting = updateTextSetting(sourceId, change)
      break
    case 'link':
      foundSetting = updateLinkSetting(sourceId, change)
      break
    default:
      // ok, we can't cherry-pick the modification so we have to refresh the whole section
      break
  }

  // if we couldn't find the setting, we have to refresh the whole section
  // so we send a message to the editor to refresh the whole section
  postMessageToEditor('setting:updated', { 
    sectionId, 
    sourceId, 
    change,
    updated: foundSetting
  })
}

const updateStyle = async (event) => {
  const { style } = event.detail

  const doc = await getUpdatedDoc({
    style: JSON.stringify(style),
  })

  // update the CSS variables
  const selector = '#maglev-style'
  const sourceElement = doc.querySelector(selector)
  let targetElement = previewDocument.querySelector(selector)

  if (sourceElement) {
    targetElement.replaceWith(sourceElement)
  }
}

// === Helpers ===

const updateTextSetting = (sourceId, change) => {
  console.log('[DOM Operations] updateTextSetting', sourceId, change)
  const selector = `[data-maglev-id='${sourceId}.${change.settingId}']`
  const settings = previewDocument.querySelectorAll(selector)
  settings.forEach(($el) => ($el.innerHTML = change.value))
  return settings.length > 0
}

const updateLinkSetting = (sourceId, change) => {
  console.log('updateLinkSetting', sourceId, change)
}

const updatePreviewDocument = async ({ layoutStoreId, sectionId, insertAt = undefined, scrollToSection = false }) => {
  console.log('[DOM Operations] updatePreviewDocument', layoutStoreId, sectionId, insertAt, scrollToSection)

  const doc = await getUpdatedDoc({ section_id: sectionId })

  // NOTE: Instructions to refresh the whole document
  // removeEventListeners()
  // previewDocument.querySelector('body').replaceWith(doc.querySelector('body'))
  // setupEvents(previewDocument)

  const selector = `[data-maglev-section-id='${sectionId}']`
  const sourceElement = doc.querySelector(selector)
  let targetElement = previewDocument.querySelector(selector)

  if (!sourceElement)
    throw new Error(`Maglev section ${sectionId} not generated by the server`)

  if (targetElement) {
    targetElement.replaceWith(sourceElement)
  } else {
    insertSectionInDOM(sourceElement, layoutStoreId, insertAt)
    targetElement = previewDocument.querySelector(selector)
  }

  runScripts(sourceElement)

  if (scrollToSection)
    scrollToSectionOrBlock(targetElement)
}

const debouncedUpdatePreviewDocument = debounce(updatePreviewDocument, 150)

const insertSectionInDOM = (element, layoutStoreId, insertAt) => {
  const dropzoneSelector = `[data-maglev-${layoutStoreId}-dropzone]`
  switch (insertAt) {
    case 'top':
    case 0: {
      const parentNode = previewDocument.querySelector(dropzoneSelector)
      parentNode.prepend(element)
      break
    }
    case -1:
    case 'bottom':    
    case undefined:
    case null:
    case '': {      
      const parentNode = previewDocument.querySelector(dropzoneSelector)
      parentNode.appendChild(element)
      break
    }
    default: {
      const selector = `${dropzoneSelector} > [data-maglev-section-id]:nth-child(${insertAt})`
      const pivotElement = previewDocument.querySelector(selector)
      pivotElement.parentNode.insertBefore(element, pivotElement.nextSibling)
    }
  }
}

const getUpdatedDoc = async (attributes) => {
  const response = await fetch(previewDocument.location.href, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
    body: JSON.stringify({
      ...attributes,
      ...csrfParam,
    }),
  })
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  
  const data = await response.text()
  const parser = new DOMParser()
  const doc = parser.parseFromString(data, 'text/html')
  return doc
}

const scrollToSectionOrBlock = (element) => {
  const previewWindow = previewDocument.defaultView
  const scrollY = previewWindow.scrollY || 0
  const elementTop = element.getBoundingClientRect().top + scrollY
  previewWindow.scrollTo({
    top: elementTop,
    behavior: 'smooth',
  })
}
