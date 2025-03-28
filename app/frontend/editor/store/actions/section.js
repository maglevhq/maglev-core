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
  // source: the information related to the section we want to mirror in the current page
  // target: the information about where to put the new section (layoutGroupId, insertAt)
  async addMirroredSection(
    { commit, getters },
    { source, target: { layoutGroupId, insertAt } },
  ) {
    // get the content of the section we want to mirror
    const section = await services.sectionsContent.findSingleSection(source.pageId, source.layoutGroupId, source.sectionId)

    section.mirrorOf = { enabled: true, ...source }

    commit('ADD_SECTION', { layoutGroupId, section, insertAt })
    commit('TOUCH_SECTION', section.id)

    services.livePreview.addSection(layoutGroupId, getters.content, section, insertAt)

    return section
  },
  async toggleMirroredSectionEnabled({ commit, dispatch }, enabled) {
    commit('SET_SECTION_MIRROR_OF_ENABLED', enabled)

    if (!enabled) return

    // update the content of the current section with the one from the mirror
    dispatch('updateMirrorOfSectionContent')
  },
  async updateMirrorOfSectionContent({ state, commit, getters }) {
    const mirrorOf = state.section.mirrorOf
    const section = await services.sectionsContent.findSingleSection(mirrorOf.pageId, mirrorOf.layoutGroupId, mirrorOf.sectionId)

    section.mirrorOf = { enabled: true, ...mirrorOf }

    commit('SET_SECTION', section) // required to update the current section form
    commit('SET_SECTION_CONTENT', section) // required to prepare the update of the preview iframe
    commit('TOUCH_SECTION', state.section.id)

    services.livePreview.updateSection(
      getters.sectionLayoutGroupIdMap[state.section.id],
      getters.content,
      getters.denormalizedSection,
      {},
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
