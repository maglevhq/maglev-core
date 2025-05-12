export default (api) => ({
  findAll: (collectionId, filters) => {
    console.log(
      `[CollectionItem] Fetching all the items of ${collectionId}`,
      filters,
    )
    const options = { params: filters || {} }
    return api
      .get(`/collections/${collectionId}`, options)
      .then(({ data }) => data)
  },
  findOne: (collectionId, id) => {
    console.log(
      `[CollectionItem] Fetching the item ${id} of ${collectionId}`,
    )
    return api
      .get(`/collections/${collectionId}/${id}`)
      .then(({ data }) => data)
  },
})
