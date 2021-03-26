import { isBlank, uuid8, truncate } from '@/utils'
import { normalize as coreNormalize } from 'normalizr'
import { SECTION_SCHEMA } from './page'

const NUMBER_OF_DEFAULT_BLOCKS = 3

export const calculateMovingIndices = (sectionIds, sectionId, direction) => {
  if (direction !== 'up' && direction !== 'down') return false

  const fromIndex = sectionIds.indexOf(sectionId)
  const toIndex = fromIndex + (direction === 'up' ? -1 : 1)

  if (toIndex < 0 || toIndex > sectionIds.length - 1) return false

  return { fromIndex, toIndex }
}

export const normalize = section => {
  return coreNormalize(section, SECTION_SCHEMA)
}

export const build = definition => {
  return {
    id: uuid8(),
    type: definition.id,
    settings: buildSettings(definition),
    blocks: buildDefaultBlocks(definition),
  }
}

export const buildDefaultBlock = (blockType, { blocks: definitions }) => {
  if (isBlank(definitions)) return null
  let definition = definitions.find(definition => definition.type === blockType) || definitions[0]  
  return {
    id: uuid8(),
    type: definition.type,
    settings: buildSettings(definition),
  }
}

const buildSettings = definition => {
  let settings = {}
  definition.settings.forEach(setting => {
    let value = null
    switch (setting.type) {
      case 'image_picker':
        value = { url: setting.default }
        break  
      default:
        value = setting.default
        break
    }
    settings[setting.id] = value
  })
  return settings
}

const buildDefaultBlocks = definition => {
  if (isBlank(definition.blocks)) return []
  let blocks = []
  Array.from({ length: NUMBER_OF_DEFAULT_BLOCKS }, () => blocks.push(
    buildDefaultBlock(null, definition)
  ))
  return blocks
}

export const getBlockLabel = (block, definition) => {
  let label, image
  definition.settings.forEach(setting => {
    const value = block.settings[setting.id]
    switch (setting.type) {
      case 'text':
        if (!label) {
          label = value
          if (setting.html) {
            let doc = new DOMParser().parseFromString(label, 'text/html')
            label = doc.body.textContent
          }
        }
        break
      case 'image_picker':
        if (!image) {
          image = value?.url
        }
        break      
      default:
        break
    }
  })
  return [
    isBlank(label) ? null : label,
    image
  ]
}