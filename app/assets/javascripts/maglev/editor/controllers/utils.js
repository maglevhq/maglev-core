export const isSamePath = (targetPath) => {
  const current = new URL(window.location.href)
  const target  = new URL(targetPath, window.location.origin)

  return current.pathname === target.pathname
}

export const sleep = (ms) => {
  return new Promise(resolve => setTimeout(resolve, ms))
}

function uuidv4() {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, c => {
    const r = Math.random() * 16 | 0
    const v = c === "x" ? r : (r & 0x3 | 0x8)
    return v.toString(16)
  })
}

export function generateRequestId() {
  // use the native randomUUID function if available (Browsers don't expose it for non-secure domains)
  if (window.crypto?.randomUUID) {
    return window.crypto.randomUUID()
  }
  return uuidv4()
}