export default (services) => ({
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
})
