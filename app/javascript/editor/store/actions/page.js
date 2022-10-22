import { isBlank } from '@/misc/utils'

export default (services) => ({
  // Fetch a page from an id (or a path)
  fetchPage({ commit, state: { site } }, id) {
    setTimeout(
      () =>
        services.page
          .findById(site, id)
          .then((page) => commit('SET_PAGE', page)),
      100,
    )
  },
  // Persist the content of a page (including or not the site content)
  async persistPage({
    commit,
    dispatch,
    state: { page, site, style },
    getters: { content, defaultPageAttributes },
  }) {
    commit('SET_SAVE_BUTTON_STATE', 'inProgress')

    const pageAttributes = {
      sections: content.pageSections,
      lockVersion: page.lockVersion,
      ...defaultPageAttributes,
    }
    const siteAttributes = isBlank(content.siteSections)
      ? { style }
      : {
          sections: content.siteSections,
          lockVersion: site.lockVersion,
          style,
        }

    services.page
      .update(page.id, pageAttributes, siteAttributes)
      .then(() => {
        commit('SET_SAVE_BUTTON_STATE', 'success')
        commit('RESET_TOUCHED_SECTIONS')
        Promise.all([dispatch('fetchPage', page.id), dispatch('fetchSite')])
      })
      .catch(({ response: { status } }) => {
        commit('SET_SAVE_BUTTON_STATE', 'fail')
        console.log('[Maglev] could not save the page', status)
        if (status === 409) commit('OPEN_ERROR_MODAL', 'staleRecord')
      })
  },
  setCurrentPageSettings({ commit }, pageSettings) {
    commit('SET_PAGE_SETTINGS', pageSettings)
  },
})
