import router from '@/router'
import store from '@/store'

let iframe = null

// the editor modifies the content of a section setting
export const updateSectionSetting = (content, section, sectionBlock, change) => {
  postMessage('section:setting:update', { content, section, sectionBlock, change })
}

// Start everything
export const start = (newIframe) => {
  // keep a reference to the current iframe
  iframe = newIframe

  // say hi to the iFrame by giving it the configuration
  postMessage('config', { primaryColor: store.state.editorSettings.primaryColor })

  // treat all the message coming from the iFrame
  listenMessages()
}

const listenMessages = () => {
  window.addEventListener('message', ({ data: { type, ...data }}) => {
    // a message MUST have a type
    if (!type) return
    
    switch (type) {
      case 'ready':
        store.dispatch('markPreviewAsReady')
        break
      case 'scroll': 
        notifyScrolling(data.boundingRect)
        break
      case 'section:hover':
        store.dispatch('hoverSection', { 
          sectionId: data.sectionId, 
          sectionRect: data.sectionRect,
          sectionOffsetHeight: data.sectionOffsetHeight
        })
        break
      case 'section:leave':
        console.log('👷🏽 section:leave')
        break
      case 'section:setting:clicked':
        openSettingPane('editSectionSetting', data)
        break
      case 'block:setting:clicked':
        openSettingPane('editSectionBlockSetting', data)
        break
      default:
        console.log('[maglev][mainWindow] unknown message type', type)
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

const notifyScrolling = (boundingRect) => {
  const event = new CustomEvent('maglev:preview:scroll', {
    detail: { boundingRect },
  })
  window.dispatchEvent(event)
}