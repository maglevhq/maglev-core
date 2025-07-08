import { start as decorateIframe } from './iframe-decorator'

const mainWindow = window.parent

export const listenMessages = () => {
  window.addEventListener('message', ({ data: { type, ...data } }) => {
    // a message MUST have a type
    if (!type) return

    switch (type) {
      case 'config':
        decorateIframe({
          primaryColor: data.primaryColor,
          stickySectionIds: data.stickySectionIds,
        })

        // we answer back we're ready!
        postMessage('ready', { message: "👋, I'm a Maglev site and I'm ready" })
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
      case 'style:update':
        triggerEvent(type, data)
        break
      default:
        console.log('[maglev][iframe] unknown message type', type)
        break
    }
  })
}

export const postMessage = (type, data) => {
  mainWindow.postMessage({ type, ...(data || {}) }, '*')
}

// local event
const triggerEvent = (type, data) => {
  const event = new CustomEvent(`maglev:${type}`, { detail: data })
  window.dispatchEvent(event)
}
