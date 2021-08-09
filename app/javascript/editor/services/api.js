import * as axios from 'axios'
import camelcaseObjectDeep from 'camelcase-object-deep'
import store from '@/store'

const token = document.querySelector('[name=csrf-token]').content
axios.defaults.headers.common['X-CSRF-TOKEN'] = token

const api = axios.create({
  baseURL: window.apiBaseUrl,
  timeout: 50000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
  transformResponse(data) {
    // camelcase in JS
    // console.log('[DEBUG] API response', data)
    return data ? camelcaseObjectDeep(JSON.parse(data)) : {}
    // return data ? JSON.parse(data) : {} // LEGACY
  },
})

api.interceptors.request.use(
  (config) => {
    config.headers['X-MAGLEV-SITE-HANDLE'] = store.state.site?.handle
    return config
  },
  (error) => Promise.reject(error),
)

export default api
