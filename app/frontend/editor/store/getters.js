export default (services) => ({
  // we need it to build the "Organize sections" pane
  sectionsContent: (
    { sectionsContent, layoutGroups, sections, sectionBlocks },
    { sectionDefinition: getSectiondefinition, layoutGroupDefinition: getLayoutGroupDefinition },
  ) => {
    const content = services.sectionsContent.denormalize(sectionsContent, {
      layoutGroups,
      sections,
      blocks: sectionBlocks
    })

    return content.map(layoutGroup => {
      const layoutDefinition = getLayoutGroupDefinition(layoutGroup.id)
      return {
        label: layoutDefinition.label,
        ...layoutGroup,
        sections: layoutGroup.sections.map(sectionContent => {
          const sectionDefinition = getSectiondefinition(sectionContent)
          return {
            id: sectionContent.id,
            type: sectionContent['type'],
            name: sectionDefinition.name,
            viewportFixedPosition: !!sectionDefinition.viewportFixedPosition,
          }
        })
      }
    })
  },

  sectionList: (
    { page, sections, sectionBlocks },
    { sectionDefinition: getSectiondefinition },
  ) => {
    throw 'DEPRECATED'

    console.log('🚨🚨🚨 getters.sectionList is deprecated')
    return []

    // // TODO: ???
    // console.log('HERE!!!')

    // const 


    // const pageContent = services.page.denormalize(page, {
    //   sections,
    //   blocks: sectionBlocks,
    // })
    // if (!pageContent?.sections) return []
    // return pageContent.sections.map((sectionContent) => {
    //   const sectionDefinition = getSectiondefinition(sectionContent)
    //   return {
    //     id: sectionContent.id,
    //     type: sectionContent['type'],
    //     name: sectionDefinition.name,
    //     viewportFixedPosition: !!sectionDefinition.viewportFixedPosition,
    //   }
    // })
  },
  stickySectionList: ({ sections }, { sectionDefinition: getSectiondefinition }) => {
    return Object.values(sections).filter((sectionContent) => {
      const sectionDefinition = getSectiondefinition(sectionContent)
      return !!sectionDefinition.viewportFixedPosition
    })
  },
  defaultPageAttributes: ({ page }) => {
    if (page.translated) return {}
    return { title: page.title, path: page.path }
  },
  content: (
    { sectionsContent, layoutGroups, sections, sectionBlocks, touchedSections }
  ) => {
    const content = services.sectionsContent.denormalize(sectionsContent, {
      layoutGroups,
      sections,
      blocks: sectionBlocks,
    })

    return content

    // const pageContent = services.page.denormalize(page, {
    //   sections,
    //   blocks: sectionBlocks,
    // })

    // const siteSections = pageContent.sections.filter(
    //   (sectionContent) => getSectiondefinition(sectionContent).siteScoped,
    // )
    // const hasModifiedSiteScopedSections = siteSections.some(
    //   (sectionContent) => touchedSections.indexOf(sectionContent.id) !== -1,
    // )
    // return {
    //   pageSections: pageContent.sections,
    //   siteSections: hasModifiedSiteScopedSections ? siteSections : [],
    // }
  },
  denormalizedSection: ({ section: { id: sectionId } }, { content }) => {
    for (const layoutGroupId in content) {
      const sections = content[layoutGroupId].sections
      const section = sections.find(s => s.id === sectionId)
      if (section) return section
    }
    return null // it mustn't happen
    // // const pageContent = services.page.denormalize(page, {
    // //   sections,
    // //   blocks: sectionBlocks,
    // // })
    // return pageContent.sections.find((s) => s.id == section.id)
  },
  sectionContent: ({ section }) => {
    return section ? [...section.settings] : null
  },
  layoutDefinition:
    ({ theme, page }) => {
      return theme.layouts.find(layout => layout.id === page.layoutId)
    },
  layoutGroupDefinition:
    ({}, { layoutDefinition }) =>
    (layoutGroupId) => {
      return layoutDefinition.groups.find(group => group.id === layoutGroupId)
    },
  sectionLayoutGroupIdMap:
    ({ layoutGroups }) => {
      const memo = {}
      for (const layoutGroupId in layoutGroups) {
        layoutGroups[layoutGroupId].sections.forEach(sectionId => {
          memo[sectionId] = layoutGroupId
        })
      }
      return memo
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
