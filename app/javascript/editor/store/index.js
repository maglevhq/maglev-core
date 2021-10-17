import Vue from 'vue'
import Vuex from 'vuex'
import defaultState from './default-state'
import actions from './actions'
import mutations from './mutations'
import getters from './getters'

Vue.use(Vuex)

const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  state: { ...defaultState },
  mutations,
  actions,
  getters,
  modules: {},
})

store.dispatch('fetchEditorSettings')
store.dispatch('fetchSite', true)
store.dispatch('setTheme', window.theme)
store.dispatch('setLocale', window.locale)

export default store
