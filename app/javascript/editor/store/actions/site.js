export default (services) => ({
  fetchSite({ commit }, locally) {
    services.site.find(locally).then((site) => {
      services.api.setSiteHandle(site.handle)
      commit('SET_SITE', site)
    })
  },
  loadPublishButtonState({ commit }) {
    services.site
      .getLastPublication()
      .then((data) => commit('SET_PUBLISH_BUTTON_STATE', data))
  },
  async publishSite({ commit }) {
    services.site
      .publish()
      .then((data) => commit('SET_PUBLISH_BUTTON_STATE', data))
  },
  pollLastPublication({ dispatch }) {
    dispatch('loadPublishButtonState')
    setInterval(() => dispatch('loadPublishButtonState'), 5000)
  },
})
