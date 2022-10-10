import { start as decorateIframe } from './iframe-decorator'

const mainWindow = window.parent

export const postMessage = (type, data) => {
  mainWindow.postMessage({ type, ...(data || {}) }, '*')
}

export const listenMessages = () => {
  window.addEventListener('message', (event) => {
    switch (event.data.type) {
      case 'config':
        decorateIframe({ 
          primaryColor: event.data.primaryColor
        })

        // we answer back we're ready!
        postMessage('ready', { message: '👋, I\'m a Maglev site and I\'m ready'})
      break
      default:
        console.log('[maglev][iframe] unknown message type', event.data.type)
        break
    }
  })
}