import { listenMessages } from './message'

const start = () => {
  if (window.location === window.parent.location) {
    return false
  }
  listenMessages()
  return true
}

export default { start }
