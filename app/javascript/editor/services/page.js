import api from './api'
import { normalize as coreNormalize, denormalize as coreDenormalize, schema } from 'normalizr'

export const BLOCK_SCHEMA = new schema.Entity('blocks')
export const SECTION_SCHEMA = new schema.Entity('sections', { blocks: [BLOCK_SCHEMA] })
export const PAGE_SCHEMA = new schema.Entity('page', { sections: [SECTION_SCHEMA] })

export const findAll = (site, filters) => {
  console.log('[PageService] Fetching all the pages', filters)
  const options = { params: filters || {} } 
  return api.get('/pages', options).then(({ data }) => data)
};

export const findById = (site, id) => {
  if (id === 'index') 
    id = site.homePageId

  console.log('[PageService] Fetching page by id', id)

  return api.get(`/pages/${id}`).then(({ data }) => data)
}

export const update = (id, attributes) => {
  console.log('[PageService] Updating page #', id)
  return api.put(`/pages/${id}`, { page: attributes })
}

export const normalize = page => {
  return coreNormalize(page, PAGE_SCHEMA)
}

export const denormalize = (page, entities) => {
  return coreDenormalize(page, PAGE_SCHEMA, entities)
}