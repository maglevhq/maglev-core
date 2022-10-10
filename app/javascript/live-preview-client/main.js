/**
 * TODO:
 * - say hi if the document has been loaded and send a message to the parent frame
 * 
 */
 

document.addEventListener('DOMContentLoaded', () => {
  if ( window.location === window.parent.location ) {
    console.log('🚨 not in the Maglev editor')
    return 
  }
  console.log('notify the parent window!')
  window.parent.postMessage({
    type: 'hello',
    message: '👋, I\'m a Nuxt app and I\'m ready'
  }, '*')
})