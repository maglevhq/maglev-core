import { isBlank } from '@/utils'

export default (services) => ({
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
    commit('TOUCH_SECTION', section.id)
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
    commit('TOUCH_SECTION', section.id)
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
    // console.log('moveSection', from, sections[from], 'to', sections[to], to)
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
})
