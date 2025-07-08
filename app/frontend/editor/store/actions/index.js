import buildSiteActions from './site'
import buildPageActions from './page'
import buildSectionActions from './section'
import buildSectionBlockActions from './section-block'

export default (services) => ({
  setDevice({ commit }, value) {
    commit('SET_DEVICE', value)
    commit('SET_HOVERED_SECTION', null)
  },
  setTheme({ commit }, theme) {
    commit('SET_THEME', theme)
  },
  setLocale({ commit }, locale) {
    services.api.setLocale(locale)
    commit('SET_LOCALE', locale)
  },
  markPreviewAsReady({ commit }) {
    commit('MARK_PREVIEW_AS_READY')
  },
  resetPreview({ commit }) {
    commit('RESET_PREVIEW')
  },
  fetchEditorSettings({ commit }) {
    commit('SET_EDITOR_SETTINGS', {
      logoUrl: window.logoUrl,
      primaryColor: window.primaryColor,
      sitePublishable: window.sitePublishable,
    })
  },
  ...buildSiteActions(services),
  ...buildPageActions(services),
  ...buildSectionActions(services),
  ...buildSectionBlockActions(services),
})
