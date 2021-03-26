import api from './api'

export const findAll = (page, perPage, query) => {
  console.log('[ImageService] Fetching all the images, page #', page, query)
  const options = { params: { page, perPage, query, assetType: 'image' } } 
  return api.get('/assets', options).then(({ data }) => data)
}

export const find = id => {
  return api.get(`/assets/${id}`).then(({ data }) => data) 
}

export const destroy = id => {
  return api.delete(`/assets/${id}`).then(({ data }) => data) 
}

export const create = attributes => {
  let formData = new FormData()
  Object.entries(attributes).forEach(
    ([key, value]) => formData.append(`asset[${key}]`, value)    
  )
  return api.post('/assets', formData)
}