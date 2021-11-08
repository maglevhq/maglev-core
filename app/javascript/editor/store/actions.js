import services from '@/services'
import { isBlank } from '@/utils'

export default {
  setDevice({ commit }, value) {
    commit('SET_DEVICE', value)
  },
  setTheme({ commit }, theme) {
    commit('SET_THEME', theme)
  },
  setLocale({ commit }, locale) {
    commit('SET_LOCALE', locale)
  },
  setPreviewDocument({ commit }, previewDocument) {
    commit('SET_PREVIEW_DOCUMENT', previewDocument)
    if (previewDocument) {
      services.inlineEditing.setup(previewDocument)
    } else {
      commit('SET_SECTION', null)
      commit('SET_HOVERED_SECTION', null)
    }
  },
  fetchEditorSettings({ commit }) {
    commit('SET_EDITOR_SETTINGS', {
      logoUrl: window.logoUrl,
      primaryColor: window.primaryColor,
    })
  },
  fetchSite({ commit }, locally) {
    services.site.find(locally).then((site) => commit('SET_SITE', site))
  },
  fetchPage({ commit, state: { site } }, id) {
    setTimeout(
      () =>
        services.page
          .findById(site, id)
          .then((page) => commit('SET_PAGE', page)),
      100,
    )
  },
  setCurrentPageSettings({ commit }, pageSettings) {
    commit('SET_PAGE_SETTINGS', pageSettings)
  },
  fetchSection({ commit, state: { sections } }, id) {
    const section = sections[id]
    commit('SET_SECTION', section)
    return section
  },
  hoverSection({ commit }, hoveredSection) {
    commit('SET_HOVERED_SECTION', hoveredSection)
  },
  leaveSection({ commit }) {
    commit('SET_HOVERED_SECTION', null)
  },
  addSection(
    { commit, getters, state: { site, previewDocument } },
    { sectionDefinition, insertAt },
  ) {
    if (sectionDefinition.insertAt) insertAt = sectionDefinition.insertAt
    const section = services.section.build(sectionDefinition, site)
    commit('ADD_SECTION', { section, insertAt })
    services.inlineEditing.addSection(
      previewDocument,
      getters.content,
      section,
      insertAt,
    )
    return section
  },
  removeSection({ commit, state: { previewDocument } }, sectionId) {
    commit('REMOVE_SECTION', sectionId)
    services.inlineEditing.removeSection(previewDocument, sectionId)
  },
  updateSectionContent(
    { commit, getters, state: { previewDocument, section } },
    change,
  ) {
    commit('UPDATE_SECTION_CONTENT', change)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,
      section,
      null,
      change,
    )
  },
  moveSection(
    {
      commit,
      state: {
        previewDocument,
        page: { sections },
      },
    },
    { from, to },
  ) {
    console.log('moveSection', from, sections[from], 'to', sections[to], to)
    if (isBlank(from) || isBlank(to)) return
    commit('MOVE_HOVERED_SECTION', { fromIndex: from, toIndex: to })
    services.inlineEditing.updateMoveSection(
      previewDocument,
      sections[from],
      sections[to],
      from < to ? 'down' : 'up',
    )
  },
  moveHoveredSection(
    {
      dispatch,
      state: {
        hoveredSection: { sectionId },
        page: { sections },
      },
    },
    direction,
  ) {
    const indices = services.section.calculateMovingIndices(
      sections,
      sectionId,
      direction,
    )
    dispatch('moveSection', { from: indices.fromIndex, to: indices.toIndex })
  },
  addSectionBlock(
    { commit, getters, state: { previewDocument, section, sectionDefinition } },
    { blockType, parentId },
  ) {
    console.log(blockType, parentId)
    const sectionBlock = services.section.buildDefaultBlock(
      blockType,
      sectionDefinition,
    )
    if (parentId) sectionBlock.parentId = parentId
    commit('ADD_SECTION_BLOCK', sectionBlock)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,
      section,
      sectionBlock,
      null,
    )
  },
  removeSectionBlock(
    { commit, getters, state: { previewDocument, section } },
    id,
  ) {
    commit('REMOVE_SECTION_BLOCK', id)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,
      section,
      null,
      null,
    )
  },
  sortSectionBlocks(
    { commit, getters, state: { previewDocument, section } },
    change,
  ) {
    commit('SORT_SECTION_BLOCKS', change)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,
      section,
      null,
      null,
    )
  },
  updateSectionBlockContent(
    { commit, getters, state: { previewDocument, section, sectionBlock } },
    change,
  ) {
    commit('UPDATE_SECTION_BLOCK_CONTENT', change)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,
      section,
      sectionBlock,
      change,
    )
  },
  fetchSectionBlock({ commit, state: { sections, sectionBlocks } }, id) {
    const sectionBlock = sectionBlocks[id]
    if (sectionBlock) {
      const section = Object.values(sections).find(
        (section) => (section.blocks || []).indexOf(sectionBlock?.id) !== -1,
      )
      commit('SET_SECTION', section) // NOTE: order is important here
      commit('SET_SECTION_BLOCK', sectionBlock)
    }
    return sectionBlock
  },
}
