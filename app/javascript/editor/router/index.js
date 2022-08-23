import { createRouter, createWebHashHistory } from 'vue-router'
import routes from './routes'
import store from '@/store'

const router = createRouter({
  history: createWebHashHistory(),
  base: window.baseUrl,
  routes,
})

router.beforeEach((to, from, next) => {
  if (to.params.pageId !== from.params.pageId && from.params.pageId)
    store.dispatch('setPreviewDocument', null) // force the display of the loader
  next()
})

export default router
