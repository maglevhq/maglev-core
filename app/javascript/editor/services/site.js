import api from './api'

export const find = async locally => {
  // NOTE: we save a request to the API by attaching the site to the Window object
  if (locally) return window.site

  console.log('[SiteService] Fetching current site')

  return api.get(`/site`).then(({ data }) => data)
}
