import Vue from 'vue'
import Vuex from 'vuex'
import defaultState from './default-state'
import buildActions from './actions'
import buildMutations from './mutations'
import buildGetters from './getters'
import services from '@/services'

Vue.use(Vuex)

const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  state: { ...defaultState },
  mutations: buildMutations(services),
  actions: buildActions(services),
  getters: buildGetters(services),
  modules: {},
})

store.dispatch('fetchEditorSettings')
store.dispatch('fetchSite', true)
store.dispatch('setTheme', window.theme)
store.dispatch('setPage', window.page)
store.dispatch('setLocale', window.locale)

if (store.state.editorSettings.sitePublishable)
  store.dispatch('pollLastPublication')

export default store
