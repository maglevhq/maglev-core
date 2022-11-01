import * as axios from 'axios'
import camelcaseObjectDeep from 'camelcase-object-deep'

let siteHandle = null
let locale = null

export const setSiteHandle = (handle) => (siteHandle = handle)
export const setLocale = (newLocale) => (locale = newLocale)

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
    config.headers['X-MAGLEV-SITE-HANDLE'] = siteHandle
    config.headers['X-MAGLEV-LOCALE'] = locale
    return config
  },
  (error) => Promise.reject(error),
)

export const get = api.get
export const post = api.post
export const put = api.put
export const destroy = api.delete
