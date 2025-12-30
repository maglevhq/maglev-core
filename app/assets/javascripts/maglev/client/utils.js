export const isBlank = (object) => {
  return (
    object === undefined ||
    object === null ||
    (typeof object === 'string' && object.length === 0) ||
    (typeof object === 'object' && object.length === 0)
  )
}

export const debounce = (fn, time) => {
  const pendingTimeouts = new Map()
  
  function wrapper(...args) {
    // Create a key from the arguments to track different argument sets separately
    const key = JSON.stringify(args)
    
    // If there's already a pending call with the same arguments, cancel it
    if (pendingTimeouts.has(key)) {
      clearTimeout(pendingTimeouts.get(key))
    }
    
    // Schedule the new call
    const timeoutId = setTimeout(() => {
      pendingTimeouts.delete(key)
      fn(...args)
    }, time)
    
    pendingTimeouts.set(key, timeoutId)
  }
  
  return wrapper
}

export const postMessageToEditor = (type, data) => {
  window.parent.dispatchEvent(new CustomEvent(`client:${type}`, { detail: data || {} }))
}