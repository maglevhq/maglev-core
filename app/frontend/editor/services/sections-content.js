import {
  normalize as coreNormalize,
  denormalize as coreDenormalize,
  schema,
} from 'normalizr'
import { pick } from '@/misc/utils'

export const BLOCK_SCHEMA = new schema.Entity('blocks')
export const SECTION_SCHEMA = new schema.Entity('sections', {
  blocks: [BLOCK_SCHEMA],
})
export const LAYOUT_GROUP_SCHEMA = new schema.Entity('layoutGroups', {
  sections: [SECTION_SCHEMA],
})
export const SECTIONS_CONTENT_SCHEMA = new schema.Array(LAYOUT_GROUP_SCHEMA)

const findSectionsContent = (api, pageId) => {
  return api.get(`/pages/${pageId}/sections_content`).then(({ data }) => data)
}

export default (api) => ({
  normalize: (content) => {
    return coreNormalize(content, SECTIONS_CONTENT_SCHEMA)
  },
  normalizeSection: (content) => {
    return coreNormalize(content, SECTION_SCHEMA)
  },
  denormalize: (content, entities) => {
    return coreDenormalize(content, SECTIONS_CONTENT_SCHEMA, entities)
  },
  find: (pageId) => {
    return findSectionsContent(api, pageId)
  },
  update: (pageId, content) => {
    console.log('[SectionsContentService] Updating content of page #', pageId)
    return api.put(`/pages/${pageId}/sections_content`, { sections_content: content }).then(({ data }) => data)
  },
  findSingleSection: async (pageId, layoutGroupId, sectionId) => {
    const pageContent = await findSectionsContent(api, pageId)
    const layoutGroup = pageContent?.find(layoutGroup => layoutGroup.id === layoutGroupId)
    return layoutGroup?.sections?.find(section => section.id === sectionId)
  }
})
