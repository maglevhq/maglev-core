import { isBlank } from '@/misc/utils'

export default (services) => ({
  pageUrl: ({ page, site }) => {
    return isBlank(baseUrl) ? page.previewUrl : new URL(page.liveUrl, site.baseUrl).toString()
  },
  sectionList: (
    { page, sections, sectionBlocks },
    { sectionDefinition: getSectiondefinition },
  ) => {
    const pageContent = services.page.denormalize(page, {
      sections,
      blocks: sectionBlocks,
    })
    if (!pageContent?.sections) return []
    return pageContent.sections.map((sectionContent) => {
      const sectionDefinition = getSectiondefinition(sectionContent)
      return {
        id: sectionContent.id,
        type: sectionContent['type'],
        name: sectionDefinition.name,
        viewportFixedPosition: !!sectionDefinition.viewportFixedPosition,
      }
    })
  },
  stickySectionList: (_, { sectionList }) => {
    return sectionList.filter((section) => section.viewportFixedPosition)
  },
  defaultPageAttributes: ({ page }) => {
    if (page.translated) return {}
    return { title: page.title, path: page.path }
  },
  content: (
    { page, sections, sectionBlocks, touchedSections },
    { sectionDefinition: getSectiondefinition },
  ) => {
    const pageContent = services.page.denormalize(page, {
      sections,
      blocks: sectionBlocks,
    })

    const siteSections = pageContent.sections.filter(
      (sectionContent) => getSectiondefinition(sectionContent).siteScoped,
    )
    const hasModifiedSiteScopedSections = siteSections.some(
      (sectionContent) => touchedSections.indexOf(sectionContent.id) !== -1,
    )
    return {
      pageSections: pageContent.sections,
      siteSections: hasModifiedSiteScopedSections ? siteSections : [],
    }
  },
  denormalizedSection: ({ page, sections, sectionBlocks, section }) => {
    const pageContent = services.page.denormalize(page, {
      sections,
      blocks: sectionBlocks,
    })
    return pageContent.sections.find((s) => s.id == section.id)
  },
  sectionContent: ({ section }) => {
    return section ? [...section.settings] : null
  },
  sectionDefinition:
    ({ theme }) =>
    (sectionContent) => {
      return theme.sections.find(
        (definition) => definition['id'] === sectionContent['type']
      )
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
    (sectionBlock, index) => {
      const definition = sectionDefinition.blocks.find(
        (def) => def.type === sectionBlock.type,
      )
      return services.section.getBlockLabel(sectionBlock, definition, index)
    },
  sectionBlockIndex: ({ section, sectionBlock }) => {
    // console.log(section.blocks, sectionBlock)
    return sectionBlock ? section.blocks.indexOf(sectionBlock.id) + 1 : null
  },
  sectionBlockContent: ({ sectionBlock }) => {
    return sectionBlock ? [...sectionBlock.settings] : null
  },
  sectionBlockSettings:
    ({ sectionBlockDefinition }) =>
    (advanced) => {
      return services.section.getSettings(sectionBlockDefinition, advanced)
    },
})
