import axios from 'axios'
import { debounce } from './utils'
import runScripts from './run-scripts'

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

const start = () => {
  // Within a Rails site, no need to remove the event listeners
  window.addEventListener('maglev:section:add', addSection)
  window.addEventListener('maglev:section:move', moveSections)
  window.addEventListener('maglev:section:update', updateSection)
  window.addEventListener('maglev:section:remove', removeSection)
  window.addEventListener('maglev:block:add', replaceSection)
  window.addEventListener('maglev:block:move', replaceSection)
  window.addEventListener('maglev:block:update', updateBlock)
  window.addEventListener('maglev:block:remove', replaceSection)

  window.addEventListener('maglev:style:update', updateStyle)
}

export default { start }

// === Section related actions ===

const addSection = (event) => {
  const { layoutGroupId, content, section, insertAt } = event.detail
  debouncedUpdatePreviewDocument(layoutGroupId, content, section, insertAt)
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
      targetSectionElement.nextElementSibling,
    )

  // scroll to the new placement of the section
  sectionElement.scrollIntoView(true)
}

const updateSection = (event) => {
  const { layoutGroupId, content, section, change } = event.detail
  updateSectionOrBlock(layoutGroupId, content, section, section, change)
}

const removeSection = (event) => {
  const { sectionId } = event.detail
  const selector = `[data-maglev-section-id='${sectionId}']`
  let element = previewDocument.querySelector(selector)
  element.remove()
}

// === Block related actions ===

const updateBlock = (event) => {
  const { layoutGroupId, content, section, sectionBlock, change } = event.detail
  updateSectionOrBlock(layoutGroupId, content, section, sectionBlock, change)
}

const replaceSection = (event) => {
  const { layoutGroupId, content, section } = event.detail
  debouncedUpdatePreviewDocument(layoutGroupId, content, section)
}

// === Other actions ===

const updateStyle = async (event) => {
  const { content, style } = event.detail

  const doc = await getUpdatedDoc({
    sectionsContent: JSON.stringify(content),
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

const updateSectionOrBlock = (layoutGroupId, content, section, source, change) => {
  const foundSetting = updateSetting(source, change)
  if (!foundSetting) debouncedUpdatePreviewDocument(layoutGroupId, content, section)
}

const updateSetting = (source, change) => {
  switch (change.settingType) {
    case 'text':
      return updateTextSetting(source, change)
    case 'link':
      if (change.settingOptions.withText && change.value)
        return updateTextSetting(source, {
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

const updateTextSetting = (source, change) => {
  const selector = `[data-maglev-id='${source.id}.${change.settingId}']`
  const settings = previewDocument.querySelectorAll(selector)
  settings.forEach(($el) => ($el.innerHTML = change.value))
  return settings.length > 0
}

const updatePreviewDocument = async (layoutGroupId, content, section, insertAt) => {
  const doc = await getUpdatedDoc({
    sections_content: JSON.stringify([
      {
        id: layoutGroupId,
        sections: [section]
      }
    ])
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
    insertSectionInDOM(sourceElement, layoutGroupId, insertAt)
    targetElement = previewDocument.querySelector(selector)
  }

  runScripts(sourceElement)

  targetElement.scrollIntoView(true)
}

const debouncedUpdatePreviewDocument = debounce(updatePreviewDocument, 300)

const insertSectionInDOM = (element, layoutGroupId, insertAt) => {
  const dropzoneSelector = `[data-maglev-${layoutGroupId}-dropzone]`
  switch (insertAt) {
    case 'top': {
      const parentNode = previewDocument.querySelector(dropzoneSelector)
      parentNode.prepend(element)
      break
    }
    case 'bottom':
    case undefined:
    case null:
    case '': {
      const parentNode = previewDocument.querySelector(dropzoneSelector)
      parentNode.appendChild(element)
      break
    }
    default: {
      const selector = `[data-maglev-section-id='${insertAt}']`
      const pivotElement = previewDocument.querySelector(selector)
      pivotElement.parentNode.insertBefore(element, pivotElement.nextSibling)
    }
  }
}

const getUpdatedDoc = async (attributes) => {
  const { data } = await axios.post(previewDocument.location.href, {
    ...attributes,
    ...csrfParam,
  })
  const parser = new DOMParser()
  const doc = parser.parseFromString(data, 'text/html')
  return doc
}
