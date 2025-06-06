import { isBlank } from '@/misc/utils'

export default (services) => ({
  fetchSectionsContent({ commit }, pageId) {
    services.sectionsContent.find(pageId)
      .then((content) => commit('SET_SECTIONS_CONTENT', content))
  },
  setSectionsContent({ commit }, content) {
    commit('SET_SECTIONS_CONTENT', content)
  },
  setSiteScopedSections({ commit }, sections) {
    commit('SET_SITE_SCOPED_SECTIONS', sections)
  },
  // Persist the "content" of a page
  async persistSectionsContent({
    commit,
    dispatch,
    state,
    getters: { content, defaultPageAttributes },
  }) {
    commit('SET_SAVE_BUTTON_STATE', 'inProgress')
    
    return services.sectionsContent
      .update(state.page.id, content)
      .then(({ lockVersions }) => {
        commit('SET_SAVE_BUTTON_STATE', 'success')
        commit('RESET_TOUCHED_SECTIONS')

        commit('SET_SECTIONS_CONTENT_LOCK_VERSIONS', lockVersions)
      })
      .catch(({ response: { status } }) => {
        commit('SET_SAVE_BUTTON_STATE', 'fail')
        console.log('[Maglev] could not save the content', status)
        if (status === 409) commit('OPEN_ERROR_MODAL', 'staleRecord')
      })
  },
})
