export default (api) => ({
  findAll: (page, perPage, query) => {
    const options = { params: { page, perPage, query, assetType: 'image' } }
    return api.get('/assets', options).then(({ data }) => data)
  },

  find: (id) => {
    return api.get(`/assets/${id}`).then(({ data }) => data)
  },

  destroy: (id) => {
    return api.destroy(`/assets/${id}`).then(({ data }) => data)
  },

  create: (attributes) => {
    let formData = new FormData()
    Object.entries(attributes).forEach(([key, value]) =>
      formData.append(`asset[${key}]`, value)
    )
    return api.post('/assets', formData, {
      headers: {
        'Content-Type': 'multipart/form-data'
      }
    })
  },
})
