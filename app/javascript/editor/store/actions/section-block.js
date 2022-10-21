export default (services) => ({
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
  addSectionBlock(
    { commit, getters, state: { section, sectionDefinition } },
    { blockType, parentId },
  ) {
    const sectionBlock = services.section.buildDefaultBlock(
      blockType,
      sectionDefinition,
    )
    if (parentId) sectionBlock.parentId = parentId
    commit('ADD_SECTION_BLOCK', sectionBlock)
    commit('TOUCH_SECTION', section.id)
    services.livePreview.addBlock(
      getters.content,
      getters.denormalizedSection,
      sectionBlock,
    )
  },
  removeSectionBlock({ commit, getters, state: { section } }, id) {
    commit('REMOVE_SECTION_BLOCK', id)
    commit('TOUCH_SECTION', section.id)
    services.livePreview.removeBlock(
      getters.content,
      getters.denormalizedSection,
      id,
    )
  },
  sortSectionBlocks({ commit, getters, state: { section } }, change) {
    commit('SORT_SECTION_BLOCKS', change)
    commit('TOUCH_SECTION', section.id)
    services.livePreview.moveBlock(getters.content, getters.denormalizedSection)
  },
  updateSectionBlockContent(
    { commit, getters, state: { section, sectionBlock } },
    change,
  ) {
    commit('UPDATE_SECTION_BLOCK_CONTENT', change)
    commit('TOUCH_SECTION', section.id)
    services.livePreview.updateBlock(
      getters.content,
      getters.denormalizedSection,
      sectionBlock,
      change,
    )
  },
})
