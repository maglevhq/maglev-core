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
    { layoutGroupId, sectionDefinition, insertAt },
  ) {
    if (sectionDefinition.insertAt) insertAt = sectionDefinition.insertAt
    const section = services.section.build(sectionDefinition, site)
    
    commit('ADD_SECTION', { layoutGroupId, section, insertAt })
    commit('TOUCH_SECTION', section.id)

    services.livePreview.addSection(layoutGroupId, getters.content, section, insertAt)

    return section
  },
  removeSection({ commit, getters }, sectionId) {
    const layoutGroupId = getters.sectionLayoutGroupIdMap[sectionId]
    commit('REMOVE_SECTION', { layoutGroupId, sectionId })
    services.livePreview.removeSection(layoutGroupId, sectionId)
  },
  updateSectionContent({ commit, getters, state: { section } }, change) {
    commit('UPDATE_SECTION_CONTENT', change)
    commit('TOUCH_SECTION', section.id)

    services.livePreview.updateSection(
      getters.sectionLayoutGroupIdMap[section.id],
      getters.content,
      getters.denormalizedSection,
      change,
    )
  },
  moveSection(
    {
      commit,
      getters,
      state: { layoutGroups },
    },
    { layoutGroupId, from, to },
  ) {
    if (isBlank(from) || isBlank(to)) return

    const sections = layoutGroups[layoutGroupId].sections

    commit('MOVE_HOVERED_SECTION', { layoutGroupId, fromIndex: from, toIndex: to })

    services.livePreview.moveSection(
      layoutGroupId,
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
        layoutGroups,
      },
      getters
    },
    direction,
  ) {
    const layoutGroupId = getters.sectionLayoutGroupIdMap[sectionId]
    const sections = layoutGroups[layoutGroupId].sections
    const indices = services.section.calculateMovingIndices(
      sections,
      sectionId,
      direction,
    )    
    dispatch('moveSection', { layoutGroupId, from: indices.fromIndex, to: indices.toIndex })
  },
})
