export const find = () => {
  // NOTE: we save a request to the API by attaching the site to the Window object
  return new Promise((successCallback, failureCallback) => {
    successCallback(window.site)
  })
}