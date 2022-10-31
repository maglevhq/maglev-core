import { listenMessages } from './message'

const start = () => {
  if (window.location === window.parent.location) {
    console.log('🚨 not in the Maglev editor')
    return
  }
  listenMessages()
}

export default { start }
