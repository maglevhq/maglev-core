import { isBlank } from '@/misc/utils'

export default (services) => ({
  // editPage : Action triggered when the user wants to edit another page
  // or to change the locale of the current page.
  async editPage({ state, dispatch }, { id, locale }) {
    // display the loader
    dispatch('resetPreview')

    if (locale && state.locale !== locale) {
      dispatch('setLocale', locale)
      await Promise.all([dispatch('fetchPage', id), dispatch('fetchSite')])
    } else await dispatch('fetchPage', id)

    dispatch('fetchSectionsContent', state.page.id)
  },

  // Set page
  setPage({ commit }, page) {
    commit('SET_PAGE', page)
  },

  // Set the oneSinglePage flag
  setOneSinglePage({ commit }, oneSinglePage) {
    commit('SET_ONE_SINGLE_PAGE', oneSinglePage)
  },

  // Reload a page: get fresh content + reload the preview iframe
  async reloadPage({ state, dispatch }, { id }) {
    await dispatch('editPage', { id })
    services.livePreview.reload()
  },

  // Fetch a page from an id (or a path)
  async fetchPage({ commit, state: { site } }, id) {
    return services.page
      .findById(site, id)
      .then((page) => commit('SET_PAGE', page))
  },  
  setCurrentPageSettings({ commit }, pageSettings) {
    commit('SET_PAGE_SETTINGS', pageSettings)
  },
})
