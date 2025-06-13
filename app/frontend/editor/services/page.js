import { pick } from '@/misc/utils'

export const SETTING_ATTRIBUTES = [
  'title',
  'path',
  'layoutId',
  'visible',
  'seoTitle',
  'ogTitle',
  'ogDescription',
  'ogImageUrl',
  'metaDescription',
  'lockVersion',
]

export default (api) => ({
  isIndex: (page) => {
    return page.path === 'index' || page.path === '/index'
  },

  build: ({ layoutId }) => {
    return {
      title: '',
      path: '',
      layoutId,
      visible: true,
      seoTitle: '',
      metaDescription: '',
    }
  },

  findAll: (filters) => {
    console.log('[PageService] Fetching all the pages', filters)
    const options = { params: filters || {} }

    const sort = (pages) => {
      return pages.sort((a, b) => {
        if (a.path === 'index') return -1
        if (b.path === 'index') return 1
        return a.title.localeCompare(b.title)
      })
    }

    return api.get('/pages', options).then(({ data }) => sort(data))
  },

  findById: (site, id) => {
    if (id === 'index') id = site.homePageId

    const safeId = String(id).replaceAll('/', '%2F')

    console.log('[PageService] Fetching page by id', safeId)

    return api.get(`/pages/${safeId}`).then(({ data }) => data)
  },

  create: (attributes) => {
    console.log('[PageService] Creating page', attributes)
    return api.post(`/pages`, { page: attributes })
  },

  update: (id, attributes, siteAttributes) => {
    console.log('🚨🚨🚨🚨🚨 [PageService] Updating page #', id)
    return api.put(`/pages/${id}`, { page: attributes, site: siteAttributes })
  },

  updateSettings: (id, attributes) => {
    console.log('[PageService] Updating page settings #', id)
    return api.put(`/pages/${id}`, {
      page: pick(attributes, ...SETTING_ATTRIBUTES),
    })
  },

  setVisible: (id, visible) => {
    console.log('[PageService] Setting page visible setting #', id)
    return api.put(`/pages/${id}`, { page: { visible } })
  },

  clone: (id) => {
    console.log('[PageService] Cloning page #', id)
    return api.post(`/pages/${id}/clones`, {})
  },

  destroy: (id) => {
    console.log('[PageService] Destroying page #', id)
    return api.destroy(`/pages/${id}`)
  },
})
