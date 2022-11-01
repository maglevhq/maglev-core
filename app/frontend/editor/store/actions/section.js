import { isBlank } from '@/misc/utils'

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
    { commit, getters, state: { site } },
    { sectionDefinition, insertAt },
  ) {
    if (sectionDefinition.insertAt) insertAt = sectionDefinition.insertAt
    const section = services.section.build(sectionDefinition, site)
    commit('ADD_SECTION', { section, insertAt })
    commit('TOUCH_SECTION', section.id)
    services.livePreview.addSection(getters.content, section, insertAt)
    return section
  },
  removeSection({ commit }, sectionId) {
    commit('REMOVE_SECTION', sectionId)
    services.livePreview.removeSection(sectionId)
  },
  updateSectionContent({ commit, getters, state: { section } }, change) {
    commit('UPDATE_SECTION_CONTENT', change)
    commit('TOUCH_SECTION', section.id)
    services.livePreview.updateSection(
      getters.content,
      getters.denormalizedSection,
      change,
    )
  },
  moveSection(
    {
      commit,
      getters,
      state: {
        page: { sections },
      },
    },
    { from, to },
  ) {
    if (isBlank(from) || isBlank(to)) return
    commit('MOVE_HOVERED_SECTION', { fromIndex: from, toIndex: to })
    services.livePreview.moveSection(
      getters.content,
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
