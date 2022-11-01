import { listenMessages } from './message'

const start = () => {
  if (window.location === window.parent.location) {
    console.log('🚨 not in the Maglev editor')
    return false
  }
  listenMessages()
  return true
}

export default { start }
