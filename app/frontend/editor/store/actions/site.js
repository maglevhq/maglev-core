export default (services) => ({
  async fetchSite({ commit }, locally) {
    return services.site.find(locally).then((site) => {
      const { style, ...rawSite } = site
      services.api.setSiteHandle(site.handle)
      commit('SET_SITE', rawSite)
      commit('SET_STYLE', style)
    })
  },
  loadPublishButtonState({ state, commit }) {
    services.site
      .getLastPublication({ pageId: state.page.id })
      .then((data) => commit('SET_PUBLISH_BUTTON_STATE', data))
  },
  async publishSite({ state, commit }) {
    services.site
      .publish({ pageId: state.page.id })
      .then((data) => commit('SET_PUBLISH_BUTTON_STATE', data))
      .catch(({ response: { status } }) => {
        console.log('[Maglev] could not publish the page', status)
        if (status === 403) commit('OPEN_ERROR_MODAL', 'forbidden')
      })
  },
  pollLastPublication({ dispatch }) {
    dispatch('loadPublishButtonState')
    setInterval(() => dispatch('loadPublishButtonState'), 5000)
  },
  previewStyle({ commit, getters }, newStyle) {
    commit('SET_STYLE', newStyle)
    services.livePreview.updateStyle(getters.content, newStyle)
  },
})
