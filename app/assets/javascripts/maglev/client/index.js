import { start as startListeningEvents } from 'maglev-client/dom-operations'
import { start as startListeningMessages } from 'maglev-client/incoming-messages'

document.addEventListener('DOMContentLoaded', () => {
  console.log('Maglev Client v2 🚆')

  // no need to start the client when the site is being visited outside the editor
  // (shouldn't happen, but just in case)
  if (window.location === window.parent.location) return

  // messages sent from the editor to the client and transformed into local events
  startListeningMessages() 

  // listen local events (converted from messages) and process them
  startListeningEvents()  
})
