// import Vue from 'vue'
import App from './App.vue'
import { createApp } from 'vue'

import stores from '@/stores'
import store from '@/store'
import router from '@/router'
import i18n from '@/plugins/i18n.js'
import createUIKit from '@/components/kit'
// import '@/mixins'
// import '@/plugins'
// import '@/components/kit'

// Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App)

  app.use(store)
  app.use(stores)
  app.use(router)
  app.use(i18n)

  createUIKit(app)

  app.mount('#maglev-app')
  // new Vue({
  //   store,
  //   router,
  //   i18n,
  //   render: (h) => h(App),
  // }).$mount('#maglev-app')
})
