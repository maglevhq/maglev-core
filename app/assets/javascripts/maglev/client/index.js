import { start as startLocalMessageManager } from 'maglev-client/local-message'
import { start as startIncomingMessageManager } from 'maglev-client/incoming-message'

document.addEventListener('DOMContentLoaded', () => {
  console.log('Maglev Client v2 🚆')

  // no need to start the client when the site is being visited outside the editor
  // (shouldn't happen, but just in case)
  if (window.location === window.parent.location) return

  startLocalMessageManager()
  startIncomingMessageManager()
})
