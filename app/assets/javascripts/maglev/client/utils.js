export const isBlank = (object) => {
  return (
    object === undefined ||
    object === null ||
    (typeof object === 'string' && object.length === 0) ||
    (typeof object === 'object' && object.length === 0)
  )
}

export const debounce = (fn, time) => {
  let timeoutId
  function wrapper(...args) {
    if (timeoutId) {
      clearTimeout(timeoutId)
    }
    timeoutId = setTimeout(() => {
      timeoutId = null
      fn(...args)
    }, time)
  }
  return wrapper
}

export const postMessageToEditor = (type, data) => {
  window.parent.dispatchEvent(new CustomEvent(`client:${type}`, { detail: data || {} }))
}