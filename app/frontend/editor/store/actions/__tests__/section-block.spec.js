import Vuex from 'vuex'
import { vi } from 'vitest'
import { createLocalVue } from '@vue/test-utils'
import defaultState from '@/store/default-state'
import buildActions from '@/store/actions'
import buildGetters from '@/store/getters'
import buildMutations from '@/store/mutations'
import MockedServices from '@/spec/__mocks__/services'
import { page, normalizedPage, pageSections } from '@/spec/__mocks__/page'
import {
  normalizedNavContentSection,
  navContentSectionBlock,
} from '@/spec/__mocks__/section'
import { site } from '@/spec/__mocks__/site'
import { theme } from '@/spec/__mocks__/theme'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('SectionBlock Actions', () => {
  let mockedServices = null
  let store = null

  beforeEach(() => {
    mockedServices = { ...MockedServices }
    store = new Vuex.Store({
      state: {
        ...defaultState,
        theme: { ...theme },
        site,
      },
      actions: buildActions(mockedServices),
      getters: buildGetters(mockedServices),
      mutations: buildMutations(mockedServices),
    })
  })

  describe('#addSectionBlock', () => {
    it('marks the current section as touched', async () => {
      mockedServices.page.normalize = vi.fn(() => normalizedPage)
      mockedServices.page.denormalize = vi.fn(() => page)
      mockedServices.section.normalize = vi.fn(
        () => normalizedNavContentSection,
      )
      mockedServices.section.buildDefaultBlock = vi.fn(
        () => navContentSectionBlock,
      )
      store.commit('SET_PAGE', page)
      store.commit('SET_SECTION', pageSections[0])
      await store.dispatch('addSectionBlock', {
        blockType: 'navbar_item',
        parentId: null,
      })
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })

  describe('#removeSectionBlock', () => {
    it('marks the current section as touched', async () => {
      mockedServices.page.normalize = vi.fn(() => normalizedPage)
      mockedServices.page.denormalize = vi.fn(() => page)
      mockedServices.section.normalize = vi.fn(
        () => normalizedNavContentSection,
      )
      store.commit('SET_PAGE', page)
      store.commit('SET_SECTION', pageSections[0])
      await store.dispatch('removeSectionBlock', 'RiEo8C3f')
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })

  describe('#sortSectionBlocks', () => {
    it('marks the current section as touched', async () => {
      mockedServices.page.normalize = vi.fn(() => normalizedPage)
      mockedServices.page.denormalize = vi.fn(() => page)
      mockedServices.section.normalize = vi.fn(
        () => normalizedNavContentSection,
      )
      store.commit('SET_PAGE', page)
      store.commit('SET_SECTION', pageSections[0])
      await store.dispatch('sortSectionBlocks', [
        { id: 'P1fGieWs' },
        { id: 'RiEo8C3f' },
        { id: 'sDo-Dg85' },
        { id: 'K-C_zRcH' },
      ])
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })

  describe('#updateSectionBlockContent', () => {
    it('marks the current section as touched', async () => {
      mockedServices.page.normalize = vi.fn(() => normalizedPage)
      mockedServices.page.denormalize = vi.fn(() => page)
      mockedServices.section.normalize = vi.fn(
        () => normalizedNavContentSection,
      )
      store.commit('SET_PAGE', page)
      store.commit('SET_SECTION', pageSections[0])
      store.commit('SET_SECTION_BLOCK', pageSections[0].blocks[0])
      await store.dispatch('updateSectionBlockContent', {})
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })
})
