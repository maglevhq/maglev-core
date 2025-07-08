import router from '@/router'
import store from '@/store'

let iframe = null

// === Section related actions ===
export const addSection = (content, section, insertAt) => {
  postMessage('section:add', { content, section, insertAt })
}

export const moveSection = (content, sectionId, targetSectionId, direction) => {
  postMessage('section:move', {
    content,
    sectionId,
    targetSectionId,
    direction,
  })
}

// the editor modifies the content of a section setting
export const updateSection = (content, section, change) => {
  postMessage('section:update', { content, section, change })
}

export const removeSection = (sectionId) => {
  postMessage('section:remove', { sectionId })
}

export const pingSection = (sectionId) => {
  if (!sectionId) return
  postMessage('section:ping', { sectionId })
}


// === Block related actions ===
export const addBlock = (content, section, sectionBlock) => {
  postMessage('block:add', { content, section, sectionBlock })
}

export const moveBlock = (content, section) => {
  postMessage('block:move', { content, section })
}

export const updateBlock = (content, section, sectionBlock, change) => {
  postMessage('block:update', { content, section, sectionBlock, change })
}

export const removeBlock = (content, section, sectionBlockId) => {
  postMessage('block:remove', { content, section, sectionBlockId })
}

export const simulateFakeScroll = () => {
  notifyScrolling(null)
}

// === Other actions ===

export const updateStyle = (content, style) => {
  postMessage('style:update', { content, style })
}

// Start everything
export const start = (newIframe) => {
  // keep a reference to the current iframe
  iframe = newIframe

  // say hi to the iFrame by giving it the configuration
  postMessage('config', {
    primaryColor: store.state.editorSettings.primaryColor,
    stickySectionIds: store.getters.stickySectionList.map(
      (section) => section.id,
    ),
  })

  // treat all the message coming from the iFrame
  listenMessages()
}

const listenMessages = () => {
  window.addEventListener('message', ({ data: { type, ...data } }) => {
    // a message MUST have a type
    if (!type) return

    switch (type) {
      case 'ready':
        store.dispatch('markPreviewAsReady')
        break
      case 'scroll':
        notifyScrolling(data.boundingRect)
        break
      case 'section:hover': {
        store.dispatch('hoverSection', {
          sectionId: data.sectionId,
          sectionRect: data.sectionRect,
          sectionOffsetTop: data.sectionOffsetTop, //sectionOffsetHeight,
        })
        break
      }
      case 'section:leave':
        store.dispatch('leaveSection')
        break
      case 'section:setting:clicked':
        openSettingPane('editSectionSetting', data)
        break
      case 'sectionBlock:setting:clicked':
        openSettingPane('editSectionBlockSetting', data)
        break
      default:
        break
    }
  })
}

const postMessage = (type, data) => {
  if (!iframe) return null
  iframe.contentWindow.postMessage({ type, ...(data || {}) }, '*')
}

const openSettingPane = (name, params) => {
  let route = { name, params, hash: '#content' }
  router.push(route).catch((err) => {
    if (err.name !== 'NavigationDuplicated') throw err
  })
}

export const notifyScrolling = (boundingRect) => {
  const event = new CustomEvent('maglev:preview:scroll', {
    detail: { boundingRect },
  })
  window.dispatchEvent(event)
}
