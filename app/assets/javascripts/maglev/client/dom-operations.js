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
  window.addEventListener('maglev:block:add', replaceSection)
  window.addEventListener('maglev:block:move', replaceSection)
  window.addEventListener('maglev:block:update', updateBlock)
  window.addEventListener('maglev:block:remove', replaceSection)
  window.addEventListener('maglev:setting:update', updateSetting)

  window.addEventListener('maglev:style:update', updateStyle)
}

// === Section related actions ===

const addSection = (event) => {
  const { sectionId, insertAt } = event.detail
  debouncedUpdatePreviewDocument(null, { id: sectionId }, insertAt)
}

const moveSections = (event) => {
  const { sectionId, targetSectionId, direction } = event.detail

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
  scrollToSection(sectionElement)
}

const updateSection = (event) => {
  const { sectionId } = event.detail
  debouncedUpdatePreviewDocument(null, { id: sectionId })
}

const removeSection = (event) => {
  const { sectionId } = event.detail
  const selector = `[data-maglev-section-id='${sectionId}']`
  const element = previewDocument.querySelector(selector)
  element.remove()
}

// === Block related actions ===

const updateBlock = (event) => {
  const { content, section, sectionBlock, change } = event.detail
  updateSectionOrBlock(content, section, sectionBlock, change)
}

const replaceSection = (event) => {
  const { content, section } = event.detail
  debouncedUpdatePreviewDocument(content, section)
}

// === Other actions ===

const updateSetting = (event) => {
  const { sectionId, sourceId, change } = event.detail

  let foundSetting = false
  
  switch (change.settingType) {
    case 'text':
      foundSetting = updateTextSetting(sourceId, change)
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
  const { content, style } = event.detail

  const doc = await getUpdatedDoc({
    pageSections: JSON.stringify(content.pageSections),
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

const updateSectionOrBlock = (content, section, source, change) => {
  const foundSetting = legacyUpdateSetting(source, change)
  if (!foundSetting) debouncedUpdatePreviewDocument(content, section)
}

const legacyUpdateSetting = (source, change) => {
  switch (change.settingType) {
    case 'text':
      return updateTextSetting(source.id, change)
    case 'link':
      if (change.settingOptions.withText && change.value)
        return updateTextSetting(source.id, {
          ...change,
          value: change.value.text,
          settingId: `${change.settingId}.text`,
        })
      break
    default:
      // ok, we can't cherry-pick the modification so we have to refresh the whole section
      break
  }
  return false
}

const updateTextSetting = (sourceId, change) => {
  const selector = `[data-maglev-id='${sourceId}.${change.settingId}']`
  const settings = previewDocument.querySelectorAll(selector)
  settings.forEach(($el) => ($el.innerHTML = change.value))
  return settings.length > 0
}

const updatePreviewDocument = async (content, section, insertAt) => {
  const doc = await getUpdatedDoc({
    page_sections: content ? JSON.stringify([
      content.pageSections.find((s) => s.id == section.id), // no need to render the other sections
    ]) : null,
    section_id: section.id
  })

  // NOTE: Instructions to refresh the whole document
  // removeEventListeners()
  // previewDocument.querySelector('body').replaceWith(doc.querySelector('body'))
  // setupEvents(previewDocument)

  const selector = `[data-maglev-section-id='${section.id}']`
  const sourceElement = doc.querySelector(selector)
  let targetElement = previewDocument.querySelector(selector)

  if (!sourceElement)
    throw new Error(`Maglev section ${section.id} not generated by the server`)

  if (targetElement) {
    targetElement.replaceWith(sourceElement)
  } else {
    insertSectionInDOM(sourceElement, insertAt)
    targetElement = previewDocument.querySelector(selector)
  }

  runScripts(sourceElement)

  scrollToSection(targetElement)
}

const debouncedUpdatePreviewDocument = debounce(updatePreviewDocument, 150)

const insertSectionInDOM = (element, insertAt) => {
  switch (insertAt) {
    case 'top':
    case 0: {
      const parentNode = previewDocument.querySelector('[data-maglev-dropzone]')
      parentNode.prepend(element)
      break
    }
    case -1:
    case 'bottom':    
    case undefined:
    case null:
    case '': {      
      const parentNode = previewDocument.querySelector('[data-maglev-dropzone]')
      parentNode.appendChild(element)
      break
    }
    default: {
      const selector = `[data-maglev-dropzone] > [data-maglev-section-id]:nth-child(${insertAt})`
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

const scrollToSection = (element) => {
  previewDocument.documentElement.scrollTo({
    top: element.offsetTop,
    behavior: 'smooth',
  })
}
