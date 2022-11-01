import Client from '~/live-preview-client/index'
import RailsClient from '~/live-preview-client/rails'

document.addEventListener('DOMContentLoaded', () => {
  console.log('[Rails] Maglev Live Preview 🚀')
  if (Client.start()) {
    RailsClient.start()
  }
})
