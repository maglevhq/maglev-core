import services from '@/services'

export default {
  sectionList: ({ theme, page, sections, sectionBlocks }) => {
    const pageContent = services.page.denormalize(page, {
      sections,
      blocks: sectionBlocks,
    })
    if (!pageContent?.sections) return []
    return pageContent.sections.map((sectionContent) => {
      const sectionDefinition = theme.sections.find(
        (definition) => definition['id'] === sectionContent['type'],
      )
      return {
        id: sectionContent.id,
        type: sectionContent['type'],
        name: sectionDefinition.name,
        viewportFixedPosition: !!sectionDefinition.viewportFixedPosition,
      }
    })
  },
  defaultPageAttributes: ({ page }) => {
    if (page.translated) return {}
    return { title: page.title, path: page.path }
  },
  content: ({ page, sections, sectionBlocks }) => {
    const pageContent = services.page.denormalize(page, {
      sections,
      blocks: sectionBlocks,
    })
    return { pageSections: pageContent.sections }
  },
  sectionContent: ({ section }) => {
    return section ? [...section.settings] : null
  },
  sectionSettings:
    ({ sectionDefinition }) =>
    (advanced) => {
      return services.section.getSettings(sectionDefinition, advanced)
    },
  sectionBlocks: ({ sectionBlocks, section, sectionDefinition }) => {
    if (!section) return []
    return section.blocks
      .map((id) => {
        const sectionBlock = sectionBlocks[id]
        const definition = sectionDefinition.blocks.find(
          (def) => def.type === sectionBlock.type,
        )
        return definition ? sectionBlock : null
      })
      .filter((b) => b)
  },
  sectionBlockLabel:
    ({ sectionDefinition }) =>
    (sectionBlock) => {
      const definition = sectionDefinition.blocks.find(
        (def) => def.type === sectionBlock.type,
      )
      return services.section.getBlockLabel(sectionBlock, definition)
    },
  sectionBlockContent: ({ sectionBlock }) => {
    return sectionBlock ? [...sectionBlock.settings] : null
  },
  sectionBlockSettings:
    ({ sectionBlockDefinition }) =>
    (advanced) => {
      return services.section.getSettings(sectionBlockDefinition, advanced)
    },
}
