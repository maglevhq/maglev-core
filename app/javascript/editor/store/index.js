import { createStore } from 'vuex'
import defaultState from './default-state.js'
import buildActions from './actions'
import buildMutations from './mutations.js'
import buildGetters from './getters.js'
import services from '@/services'

const store = createStore({
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
store.dispatch('setLocale', window.locale)

if (store.state.editorSettings.sitePublishable)
  store.dispatch('pollLastPublication')

export default store