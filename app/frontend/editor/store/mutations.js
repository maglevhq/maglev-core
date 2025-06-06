import { arraymove, pick, omitEmpty } from '@/misc/utils'
import { SETTING_ATTRIBUTES as PAGE_SETTING_ATTRIBUTES } from '@/services/page'

export default (services) => ({
  SET_DEVICE(state, value) {
    state.device = value
  },
  MARK_PREVIEW_AS_READY(state) {
    state.hoveredSection = null
    state.section = null
    state.previewReady = true
  },
  RESET_PREVIEW(state) {
    state.hoveredSection = null
    state.section = null
    state.previewReady = false
  },
  SET_EDITOR_SETTINGS(state, editorSettings) {
    state.editorSettings = editorSettings
  },
  SET_SITE(state, site) {
    state.site = site
  },
  SET_STYLE(state, style) {
    state.style = style
  },
  SET_LOCALE(state, locale) {
    state.locale = locale
  },
  SET_THEME(state, theme) {
    state.theme = theme
  },
  SET_PAGE(state, page) {
    state.page = page
  },
  SET_PAGE_SETTINGS(state, page) {
    const attributes = pick(page, ...PAGE_SETTING_ATTRIBUTES)
    omitEmpty(attributes)
    state.page = { ...state.page, ...attributes }
  },
  SET_ONE_SINGLE_PAGE(state, oneSinglePage) {
    state.oneSinglePage = oneSinglePage
  },
  // === SECTIONS CONTENT ===
  SET_SECTIONS_CONTENT(state, content) {
    const { entities, result } = services.sectionsContent.normalize(content)
    
    state.sectionsContent = [...result]
    state.layoutGroups = { ...state.layoutGroups, ...entities.layoutGroups }
    state.sections = { ...state.sections, ...entities.sections }
    state.sectionBlocks = { ...state.sectionBlocks, ...entities.blocks }
    state.hoveredSection = null
  },
  SET_SITE_SCOPED_SECTIONS(state, sections) {
    state.siteScopedSections = { ...sections }
  },
  SET_SECTION_CONTENT(state, content) {
    const { entities, result } = services.section.normalize(content)

    state.sections = { ...state.sections, ...entities.sections }
    state.sectionBlocks = { ...state.sectionBlocks, ...entities.blocks }
  },
  SET_SECTIONS_CONTENT_LOCK_VERSIONS(state, lockVersions) {
    for (const { layoutGroupId, lockVersion } of lockVersions) {
      state.layoutGroups[layoutGroupId] = { 
        ...state.layoutGroups[layoutGroupId], 
        lockVersion
      }
    }
  },
  // === SECTION ===
  SET_SECTION(state, section) {
    if (section) {
      const sectionDefinition = state.theme.sections.find(
        (definition) => definition['id'] === section['type'],
      )
      state.section = { ...section }
      state.sectionDefinition = { ...sectionDefinition }
    } else state.section = state.sectionDefinition = null
  },
  SET_HOVERED_SECTION(state, hoveredSection) {
    if (!hoveredSection) {
      state.hoveredSection = null
    } else {
      const section = state.sections[hoveredSection.sectionId]
      const definition = state.theme.sections.find(
        (definition) => definition['id'] === section['type'],
      )
      state.hoveredSection = {
        ...hoveredSection,
        name: definition.name,
        definition,
      }
    }
  },
  UPDATE_SECTION_CONTENT(state, change) {
    let updatedSection = { ...state.section }
    let newContent = { id: change.settingId, value: change.value }
    let contentIndex = updatedSection.settings.findIndex(
      (content) => content.id === newContent.id,
    )

    if (contentIndex === -1) updatedSection.settings.push(newContent)
    else updatedSection.settings[contentIndex] = newContent

    state.sections[state.section.id] = updatedSection
    state.section = updatedSection
  },
  SET_SECTION_MIRROR_OF_ENABLED(state, enabled) {
    let updatedSection = { ...state.section }
    updatedSection.mirrorOf.enabled = enabled

    state.sections[state.section.id] = updatedSection
    state.section = updatedSection
  },
  ADD_SECTION(state, { layoutGroupId, section, insertAt }) {
    const {
      entities: { sections, blocks },
    } = services.section.normalize(section)
    state.sections = { ...state.sections, [section.id]: sections[section.id] }
    state.sectionBlocks = { ...state.sectionBlocks, ...blocks } // hmmm???
    const layoutGroup = { ...state.layoutGroups[layoutGroupId] }

    // use a new mem reference for the list of sections
    layoutGroup.sections = [...layoutGroup.sections]
    
    switch (insertAt) {
      case 'top':
        layoutGroup.sections.unshift(section.id)
        break
      case 'bottom':
      case undefined:
      case null:
      case '':
        layoutGroup.sections.push(section.id)
        break
      default:
        layoutGroup.sections.splice(
          layoutGroup.sections.indexOf(insertAt) + 1,
          0,
          section.id,
        )
    }

    state.layoutGroups[layoutGroupId] = layoutGroup
  },
  RESTORE_SECTION(state, sectionId) {
    const section = state.sections[sectionId]
    state.sections[sectionId] = { ...section, deleted: false }
  },
  REMOVE_SECTION(state, { layoutGroupId, sectionId, recoverable }) {
    const section = state.sections[sectionId]
    
    if (recoverable.indexOf(section.type) !== -1) {
      // soft delete the section
      state.sections[sectionId] = { ...section, deleted: true }
    } else {
      const sections = state.layoutGroups[layoutGroupId].sections
      sections.splice(sections.indexOf(sectionId), 1)
    }
  },
  MOVE_HOVERED_SECTION(state, { layoutGroupId, fromIndex, toIndex }) {
    const layoutGroup = state.layoutGroups[layoutGroupId]
    layoutGroup.sections = arraymove(layoutGroup.sections, fromIndex, toIndex)
  },
  SET_SECTION_BLOCK(state, sectionBlock) {
    state.sectionBlock = sectionBlock
    state.sectionBlockDefinition = state.sectionDefinition.blocks.find(
      (definition) => definition.type === sectionBlock.type,
    )
  },
  ADD_SECTION_BLOCK(state, sectionBlock) {
    state.sectionBlocks = {
      ...state.sectionBlocks,
      [sectionBlock.id]: sectionBlock,
    }
    const updatedSection = { ...state.sections[state.section.id] }
    updatedSection.blocks.push(sectionBlock.id)
    state.sections = { ...state.sections, [updatedSection.id]: updatedSection }
    state.section = updatedSection
  },
  REMOVE_SECTION_BLOCK(state, sectionBlockId) {
    const updatedSection = { ...state.sections[state.section.id] }
    const index = updatedSection.blocks.indexOf(sectionBlockId)
    updatedSection.blocks.splice(index, 1)
    state.sections = { ...state.sections, [updatedSection.id]: updatedSection }
    state.section = updatedSection
  },
  SORT_SECTION_BLOCKS(state, list) {
    const sections = { ...state.sections }
    sections[state.section.id].blocks = list.map((block) => block.id)
    // in case we deal with a tree structure, update the parentId attribute only
    list.forEach(
      (block) => (state.sectionBlocks[block.id].parentId = block.parentId),
    )
    state.section = { ...sections[state.section.id] }
    state.sections = sections
  },
  UPDATE_SECTION_BLOCK_CONTENT(state, change) {
    let updatedBlock = { ...state.sectionBlocks[state.sectionBlock.id] }
    let newContent = { id: change.settingId, value: change.value }
    let contentIndex = updatedBlock.settings.findIndex(
      (content) => content.id === newContent.id,
    )

    if (contentIndex === -1) updatedBlock.settings.push(newContent)
    else updatedBlock.settings[contentIndex] = newContent

    state.sectionBlocks[state.sectionBlock.id] = updatedBlock
    state.sectionBlock = updatedBlock
  },
  TOUCH_SECTION(state, sectionId) {
    if (state.touchedSections.indexOf(sectionId) === -1) {
      const newArray = [...state.touchedSections]
      newArray.push(sectionId)
      state.touchedSections = newArray
    }
  },
  RESET_TOUCHED_SECTIONS(state) {
    state.touchedSections = []
  },
  // === UI ===
  SET_PUBLISH_BUTTON_STATE(state, newButton) {
    state.ui.publishButtonState = newButton
  },
  SET_SAVE_BUTTON_STATE(state, buttonState) {
    state.ui.saveButtonState = buttonState
  },
  OPEN_ERROR_MODAL(state, errorType) {
    state.ui.openErrorModal = true
    state.ui.errorModalType = errorType
  },
  CLEAR_ERROR_MODAL(state) {
    state.ui.openErrorModal = false
    state.ui.errorModalType = null
  },
})
