import router from '@/router'
import store from '@/store'

let iframe = null

export const triggerEvent = (type, data) => {
  if (!iframe) return null
  iframe.contentWindow.postMessage({ type, ...(data || {}) }, '*')
}

export default (newIframe) => {
  console.log('setting the communication between the iframe and the main window...', newIframe)
  iframe = newIframe

  // say hi to the iFrame by giving the configuration
  triggerEvent('config', { primaryColor: store.state.editorSettings.primaryColor })

  window.addEventListener('message', function (event) {
    // console.log('📡 Editor receiving', event.data)
    switch (event.data.type) {
      case 'ready':
        store.dispatch('markPreviewAsReady')
        break
      case 'scroll': 
        notifyScrolling(event.data.boundingRect)
        break
      case 'section:hover':
        store.dispatch('hoverSection', { 
          sectionId: event.data.sectionId, 
          sectionRect: event.data.sectionRect,
          sectionOffsetHeight: event.data.sectionOffsetHeight
        })
        break
      case 'section:setting:clicked':
        openSettingPane('editSectionSetting', event.data)
        break
      case 'block:setting:clicked':
        openSettingPane('editSectionBlockSetting', event.data)
        break
      default:
        console.log('[maglev][mainWindow] unknown message type', event.data.type)
        break
    }
  })
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