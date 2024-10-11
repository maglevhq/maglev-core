import Vue from 'vue'
import App from './App.vue'
import store from '@/store'
import i18n from '@/initializers/i18n'
import router from '@/router'
import '@/mixins'
import '@/initializers'
import '@/components/kit'

Vue.config.productionTip = false

const start = () => {
  new Vue({
    store,
    router,
    i18n,
    render: (h) => h(App),
  }).$mount('#maglev-app')
}

export default { start }
