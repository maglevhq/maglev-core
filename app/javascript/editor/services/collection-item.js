import api from './api'

export const findAll = (collectionId, filters) => {
  console.log(`[CollectionItem] Fetching all the items of ${collectionId}`, filters)
  const options = { params: filters || {} }
  return api.get(`/collections/${collectionId}`, options).then(({ data }) => data)
}

