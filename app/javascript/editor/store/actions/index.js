import buildPageActions from './page'
import buildSectionActions from './section'
import buildSectionBlockActions from './section-block'

export default (services) => ({
  setDevice({ commit }, value) {
    commit('SET_DEVICE', value)
  },
  setTheme({ commit }, theme) {
    commit('SET_THEME', theme)
  },
  setLocale({ commit }, locale) {
    services.api.setLocale(locale)
    commit('SET_LOCALE', locale)
  },
  setPreviewDocument({ commit }, previewDocument) {
    commit('SET_PREVIEW_DOCUMENT', previewDocument)
    if (previewDocument) {
      services.inlineEditing.setup(previewDocument)
    } else {
      commit('SET_SECTION', null)
      commit('SET_HOVERED_SECTION', null)
    }
  },
  fetchEditorSettings({ commit }) {
    commit('SET_EDITOR_SETTINGS', {
      logoUrl: window.logoUrl,
      primaryColor: window.primaryColor,
      sitePublishable: window.sitePublishable,
    })
  },
  fetchSite({ commit }, locally) {
    services.site.find(locally).then((site) => {
      services.api.setSiteHandle(site.handle)
      commit('SET_SITE', site)
    })
  },
  ...buildPageActions(services),
  ...buildSectionActions(services),
  ...buildSectionBlockActions(services),
})
