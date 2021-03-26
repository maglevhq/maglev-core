import Vue from 'vue'
import Vuex from 'vuex'
import services from '@/services'
import { arraymove, camelize } from '@/utils'

Vue.use(Vuex)

// load the initial state
const defaultState = {
  device: 'desktop',
  previewReady: false,
  previewDocument: null,
  site: null,
  theme: null,
  page: null,
  section: null,
  sectionDefinition: null,
  hoveredSection: null,
  sectionBlock: null,
  sectionBlockDefinition: null,
  sections: {},
  sectionBlocks: {},
}
const state = { ...defaultState }

const mutations = {
  SET_DEVICE(state, value) {
    state.device = value
  },  
  SET_PREVIEW_DOCUMENT(state, previewDocument) {
    state.section = null
    state.previewReady = true
    state.previewDocument = previewDocument
  },
  SET_SITE(state, site) {    
    state.site = site
  },
  SET_THEME(state, theme) {
    state.theme = theme
  },
  SET_PAGE(state, page) {
    console.log('SET_PAGE', { ...page })
    console.log('NORMALIZE', services.page.normalize(page).entities)
    const { entities } = services.page.normalize(page)
    state.page = entities.page[page.id]
    state.sections = { ...state.sections, ...entities.sections }
    state.sectionBlocks = { ...state.sectionBlocks, ...entities.blocks }
  },
  SET_SECTION(state, section) {
    if (section) {
      const sectionDefinition = state.theme.sections.find(definition => definition['id'] === section['type'])
      state.section = { ...section }
      state.sectionDefinition = { ...sectionDefinition }
    } else 
      state.section = state.sectionDefinition = null
  },  
  SET_HOVERED_SECTION(state, hoveredSection) {
    if (!hoveredSection) {  
      state.hoveredSection = null           
    } else {      
      const section = state.sections[hoveredSection.sectionId]
      const definition = state.theme.sections.find(definition => definition['id'] === section['type'])
      state.hoveredSection = { ...hoveredSection, name: definition.name, definition }
    }
  },  
  UPDATE_SECTION_CONTENT(state, change) {
    let updatedSection = { ...state.sections[state.section.id] }
    updatedSection.settings[change.settingId] = change.value
    state.sections[state.section.id] = updatedSection
  },
  ADD_SECTION(state, section) {
    const { entities: { sections, blocks } } = services.section.normalize(section)  
    state.sections[section.id] = sections[section.id]
    state.sectionBlocks = { ...state.sectionBlocks, ...blocks }
    state.page.sections.push(section.id) 
  },
  REMOVE_SECTION(state, sectionId) {    
    state.page.sections.splice(state.page.sections.indexOf(sectionId), 1)
  },
  MOVE_HOVERED_SECTION(state, { fromIndex, toIndex }) {    
    state.page.sections = arraymove(state.page.sections, fromIndex, toIndex)
  },
  SET_SECTION_BLOCK(state, sectionBlock) {    
    state.sectionBlock = sectionBlock
    state.sectionBlockDefinition = state.sectionDefinition.blocks.find(definition => definition.type === sectionBlock.type)
  },
  ADD_SECTION_BLOCK(state, sectionBlock) {
    state.sectionBlocks[sectionBlock.id] = sectionBlock
    state.sections[state.section.id].blocks.push(sectionBlock.id) 
    state.section = state.sections[state.section.id]
  },
  REMOVE_SECTION_BLOCK(state, sectionBlockIndex) {
    state.sections[state.section.id].blocks.splice(sectionBlockIndex, 1)
    state.section = state.sections[state.section.id]
  },
  SORT_SECTION_BLOCKS(state, list) {
    state.sections[state.section.id].blocks = list
    state.section = state.sections[state.section.id]
  },
  UPDATE_SECTION_BLOCK_CONTENT(state, change) {
    let updatedBlock = { ...state.sectionBlocks[state.sectionBlock.id] }
    updatedBlock.settings[change.settingId] = change.value
    state.sectionBlocks[state.sectionBlock.id] = updatedBlock
  }
}

const actions = {
  setDevice({ commit }, value) {
    commit('SET_DEVICE', value)
  },
  setPreviewDocument({ commit }, previewDocument) {
    commit('SET_PREVIEW_DOCUMENT', previewDocument)
    if (previewDocument)
      services.inlineEditing.setup(previewDocument)
  },
  fetchSite({ commit }) { 
    services.site.find().then(site => commit('SET_SITE', site))      
  },
  fetchPage({ commit, state: { site } }, id) {
    services.page.findById(site, id).then(page => commit('SET_PAGE', page))
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
  addSection({ commit, getters, state: { previewDocument } }, sectionDefinition) {
    const section = services.section.build(sectionDefinition)
    commit('ADD_SECTION', section)
    services.inlineEditing.addSection(
      previewDocument,
      getters.content, 
      section
    )
    return section
  },  
  removeSection({ commit, state: { previewDocument }}, sectionId) {
    commit('REMOVE_SECTION', sectionId)
    services.inlineEditing.removeSection(
      previewDocument,
      sectionId
    )
  },
  updateSectionContent({ commit, getters, state: { previewDocument, section } }, change) {
    commit('UPDATE_SECTION_CONTENT', change)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,      
      section,
      null,
      change
    )
  },
  moveHoveredSection({ commit, state: { previewDocument, hoveredSection: { sectionId }, page: { sections } } }, direction) {
    const indices = services.section.calculateMovingIndices(sections, sectionId, direction)
    if (indices) {
      commit('MOVE_HOVERED_SECTION', { ...indices })
      services.inlineEditing.updateMoveSection(
        previewDocument,
        sectionId,
        sections[indices.toIndex],
        direction
      )
    }
  },  
  addSectionBlock({ commit, getters, state: { previewDocument, section, sectionDefinition} }, blockType) {
    const sectionBlock = services.section.buildDefaultBlock(blockType, sectionDefinition)
    commit('ADD_SECTION_BLOCK', sectionBlock)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,      
      section,
      sectionBlock,
      null
    )
  },
  removeSectionBlock({ commit, getters, state: { previewDocument, section } }, index) {
    commit('REMOVE_SECTION_BLOCK', index)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,      
      section,
      null,
      null
    )
  },
  sortSectionBlocks({ commit, getters, state: { previewDocument, section } }, change) {
    commit('SORT_SECTION_BLOCKS', change)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,      
      section,
      null,
      null
    )
  },
  updateSectionBlockContent({ commit, getters, state: { previewDocument, section, sectionBlock } }, change) {
    commit('UPDATE_SECTION_BLOCK_CONTENT', change)
    services.inlineEditing.updateSectionSetting(
      previewDocument,
      getters.content,      
      section,
      sectionBlock,
      change
    )
  },
  fetchSectionBlock({ commit, state: { sections, sectionBlocks } }, id) {
    const sectionBlock = sectionBlocks[id]
    if (sectionBlock) {
      const section = Object.values(sections).find(section => 
        section.blocks.indexOf(sectionBlock?.id) !== -1
      )
      commit('SET_SECTION', section) // NOTE: order is important here
      commit('SET_SECTION_BLOCK', sectionBlock) 
    }
    return sectionBlock
  },  
}

const getters = {
  sectionBlocks: ({ sectionBlocks, section }) => {
    if (!section) return []
    return section.blocks.map(id => sectionBlocks[id])
  },
  content: ({ page, sections, sectionBlocks, section }) => {
    const pageContent = services.page.denormalize(page, { sections, blocks: sectionBlocks })
    return { pageSections: pageContent.sections }
  },  
  sectionBlockLabel: ({ sectionDefinition }) => sectionBlock => {
    const definition = sectionDefinition.blocks.find(def => def.type === sectionBlock.type)
    return services.section.getBlockLabel(sectionBlock, definition)
  }
}

const store = new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production',
  state,
  mutations,
  actions,
  getters,
  modules: {},
})

store.dispatch('fetchSite')
store.commit('SET_THEME', window.theme)

export default store