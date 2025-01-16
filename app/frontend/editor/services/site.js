export default (api) => ({
  find: async (locally) => {
    // NOTE: we save a request to the API by attaching the site to the Window object
    if (locally) return window.site

    console.log('[SiteService] Fetching current site')

    return api.get(`/site`).then(({ data }) => data)
  },
  updateStyle(style) {
    return api.put(`/style`, { site: { style } }).then((response) => {
      return response.headers['lock-version']
    })
  },
  publish({ pageId }) {
    return api.post(`/publication`, { page_id: pageId }).then(({ data }) => data)
  },
  getLastPublication({ pageId }) {
    return api.get('/publication', { params: { page_id: pageId }}).then(({ data }) => data)
  },
})
