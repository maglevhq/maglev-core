import { start as decorateIframe } from 'maglev-client/iframe-decorator'
import { postMessageToEditor } from 'maglev-client/utils'

export const start = () => {
  window.addEventListener('message', ({ data: { type, ...data } }) => {
    // a message MUST have a type
    if (!type) return

    const internalType = type.replace('maglev:', '')

    switch (internalType) {
      case 'config':
        decorateIframe({
          primaryColor: data.primaryColor,
          stickySectionIds: data.stickySectionIds,
        })

        // we answer back we're ready!
        postMessageToEditor('ready', { 
          message: "👋, I'm a Maglev site and I'm ready",
          numberOfSections: window.document.querySelectorAll('[data-maglev-section-id]').length
        })
        break
      case 'section:add':
      case 'section:move':
      case 'section:update':
      case 'section:remove':
      case 'section:ping':
      case 'block:add':
      case 'block:move':
      case 'block:update':
      case 'block:remove':
      case 'setting:update':
      case 'style:update':
        triggerEvent(type, data)
        break
      default:
        console.log('[maglev][iframe] unknown message type', type)
        break
    }
  })
}

// local event
const triggerEvent = (type, data) => {
  const event = new CustomEvent(type, { detail: data })
  window.dispatchEvent(event)
}
