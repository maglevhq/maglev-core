 import { isBlank } from '@/misc/utils.js'

export default (services) => ({
  currentPagePath: ({ page }) => {
    const nakedPath = page.liveUrl.startsWith('http') ? new URL(page.liveUrl).pathname : page.liveUrl
    return page.path === 'index' ? `${nakedPath}/index`.replace('//', '/') : nakedPath
  },
  currentPageUrl: ({ page, site }) => {
    if (page.liveUrl.startsWith('http')) return page.liveUrl
    return new URL(page.liveUrl, location.origin).toString()
  },
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
          if (sectionContent.deleted) return
          const sectionDefinition = getSectiondefinition(sectionContent)
          return {
            id: sectionContent.id,
            type: sectionContent['type'],
            name: sectionDefinition.name,
            isMirrored: sectionContent.mirrorOf?.enabled ?? false,
            mirroredPageTitle: sectionContent.mirrorOf?.pageTitle,
            viewportFixedPosition: !!sectionDefinition.viewportFixedPosition,
          }
        }).filter(content => content)
      }
    })
  },

  categoriesByLayoutGroupId: 
    ({ theme, page: { layoutId } }, { sectionsByLayoutGroupId }) => 
    (layoutGroupId) => {
      const insertedSectionTypes = sectionsByLayoutGroupId(layoutGroupId).map(section => {
        return isBlank(section.deleted) || section.deleted === false ? section.type : undefined
      }).filter(section => section)
      return services.theme.buildCategories({
        theme,
        layoutId,
        layoutGroupId,
        insertedSectionTypes
      })
    },

  // return all the section types in the page
  sectionTypes: ({ sections }) => {
    return Object.values(sections).map((section) => section.type)
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
    return services.sectionsContent.denormalize(sectionsContent, {
      layoutGroups,
      sections,
      blocks: sectionBlocks,
    })
  },
  // denormalize the current section in the state
  denormalizedSection: ({ section: { id: sectionId } }, { denormalizeSection }) => {
    return denormalizeSection(sectionId)
  },
  denormalizeSection: ({}, { content }) => 
    (sectionId) => {
    for (const layoutGroupId in content) {
      const sections = content[layoutGroupId].sections
      const section = sections.find(s => s.id === sectionId)
      if (section) return section
    }
    return null
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
  sectionsByLayoutGroupId:
    ({ layoutGroups, sections }) => 
    (layoutGroupId) => {
      for (const groupId in layoutGroups) {
        if (layoutGroupId !== groupId) continue
        const layoutGroup = layoutGroups[groupId]
        return layoutGroup.sections.map(sectionId => sections[sectionId])
      }
      return []
    },
  deletedSection:
    ({}, { layoutGroupDefinition, sectionsByLayoutGroupId }) =>
    (layoutGroupId, type) => {
      const recoverable = layoutGroupDefinition(layoutGroupId).recoverable

      // if the section isn't recoverable, no need to get further
      if (isBlank(recoverable) || recoverable.indexOf(type) === -1) return undefined

      const sections = sectionsByLayoutGroupId(layoutGroupId)
      return sections.find(section => section.type === type && section.deleted)
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
  canAddSection: 
    ({}, { categoriesByLayoutGroupId }) => 
    (layoutGroupId) => {
      const categories = categoriesByLayoutGroupId(layoutGroupId)
      return categories.some(({ children }) => children.length > 0)
    },
  canAddMirroredSection: ({ theme, oneSinglePage }, { layoutGroupDefinition }) => 
    (layoutGroupId) => {
      const layoutGroup = layoutGroupDefinition(layoutGroupId)
      return theme.mirrorSection && layoutGroup.mirrorSection !== false && services.section.canAddMirroredSection({ 
        hasOneSinglePage: oneSinglePage
      })
    },
  isMirroredSection: ({ section }) => {
    return !isBlank(section.mirrorOf)
  },
  isMirroredSectionEditable: ({ theme, section, page }, {}) => {
    return theme.mirrorSection === true || (theme.mirrorSection === 'protected' && section.mirrorOf?.pageId === page.id)
  }
})
