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
  // Persist the content of a page (including or not the site content)
  // async persistPage({
  //   commit,
  //   dispatch,
  //   state: { page, site, style },
  //   getters: { content, defaultPageAttributes },
  // }) {
  //   console.log('🚨🚨🚨 services.page.persistPage is DEPRECATED')

  //   commit('SET_SAVE_BUTTON_STATE', 'inProgress')

  //   const pageAttributes = {
  //     sections: content.pageSections,
  //     lockVersion: page.lockVersion,
  //     ...defaultPageAttributes,
  //   }
  //   const siteAttributes = isBlank(content.siteSections)
  //     ? { style }
  //     : {
  //         sections: content.siteSections,
  //         lockVersion: site.lockVersion,
  //         style,
  //       }

  //   return services.page
  //     .update(page.id, pageAttributes, siteAttributes)
  //     .then(() => {
  //       commit('SET_SAVE_BUTTON_STATE', 'success')
  //       commit('RESET_TOUCHED_SECTIONS')
  //       Promise.all([dispatch('fetchPage', page.id), dispatch('fetchSite')])
  //     })
  //     .catch(({ response: { status } }) => {
  //       commit('SET_SAVE_BUTTON_STATE', 'fail')
  //       console.log('[Maglev] could not save the page', status)
  //       if (status === 409) commit('OPEN_ERROR_MODAL', 'staleRecord')
  //     })
  // },
  setCurrentPageSettings({ commit }, pageSettings) {
    commit('SET_PAGE_SETTINGS', pageSettings)
  },
})
