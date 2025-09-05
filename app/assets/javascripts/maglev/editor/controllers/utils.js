export const isSamePath = (targetPath) => {
  const current = new URL(window.location.href)
  const target  = new URL(targetPath, window.location.origin)

  return current.pathname === target.pathname
}