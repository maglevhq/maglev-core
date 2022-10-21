import { listenMessages } from './message'

document.addEventListener('DOMContentLoaded', () => {
  if (window.location === window.parent.location) {
    console.log('🚨 not in the Maglev editor')
    return
  }
  listenMessages()
})
