export const isBlank = (object) => {
  return (
    object === undefined ||
    object === null ||
    (typeof object === 'string' && object.length === 0) ||
    (typeof object === 'object' && object.length === 0)
  )
}

const getParentEditorConfig = () => {
  try {
    return window.parent?.maglevEditorConfig
  } catch (_) {
    return undefined
  }
}

const getEditorConfig = () => {
  return window.maglevEditorConfig || getParentEditorConfig() || {}
}

export const isEditorJsLogsEnabled = () => {
  return getEditorConfig().jsLogsEnabled === true
}

export const log = (...args) => {
  if (isEditorJsLogsEnabled()) {
    console.log(...args)
  }
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