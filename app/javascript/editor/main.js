import Vue from 'vue'
import App from './App'
import store from '@/store'
import i18n from '@/plugins/i18n'
import router from '@/router'
import '@/mixins'
import '@/plugins'
import '@/components/kit'
import setupIframePreview from '@/services/iframe-preview'

Vue.config.productionTip = false

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    store,
    router,
    i18n,
    render: (h) => h(App),
  }).$mount('#maglev-app')

  setupIframePreview()
})

// console.log('window.targetWin', window.targetWin)
// window.addEventListener('message', function(event) {
//   console.log('📡 Editor receiving', event.data)
//   // if (event.origin != 'http://javascript.info') {
//   //   // something from an unknown domain, let's ignore it
//   //   return;
//   // }

//   // alert( "received: " + event.data );

//   // // can message back using event.source.postMessage(...)
// });
