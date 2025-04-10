import Vuex from 'vuex'
import { vi } from 'vitest'
import { createLocalVue } from '@vue/test-utils'
import defaultState from '@/store/default-state'
import buildActions from '@/store/actions'
import buildGetters from '@/store/getters'
import buildMutations from '@/store/mutations'
import MockedServices from '@/spec/__mocks__/services'
import {
  simpleContentSection,
  normalizedSimpleContentSection,
} from '@/spec/__mocks__/section'
import { theme } from '@/spec/__mocks__/theme'
import { site } from '@/spec/__mocks__/site'
import { page } from '@/spec/__mocks__/page'
import { normalizedSectionsContent, sectionsContent, headerSections, mainSections } from '@/spec/__mocks__/sections-content'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Section Actions', () => {
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

  describe('#addSection', () => {
    beforeEach(() => {
      mockedServices.sectionsContent.normalize = vi.fn(() => normalizedSectionsContent)
      mockedServices.sectionsContent.denormalize = vi.fn(() => sectionsContent)
      store.commit('SET_PAGE', page)
    })

    it('marks the new section as touched', async () => {
      mockedServices.section.build = vi.fn(() => simpleContentSection)
      mockedServices.section.normalize = vi.fn(
        () => normalizedSimpleContentSection,
      )
      store.commit('SET_SECTIONS_CONTENT', sectionsContent)
      await store.dispatch('addSection', {
        layoutGroupId: 'main',
        sectionDefinition: theme.sections[0],
        insertAt: 'bottom',
      })
      expect(store.state.touchedSections).toStrictEqual(['NEW-CONTENT-1'])
    })

    it('recovers a deleted section', async () => {
      const altNormalizedSectionsContent = JSON.parse(JSON.stringify(normalizedSectionsContent))
      altNormalizedSectionsContent.entities.sections['GrYZW-VP'].deleted = true
      mockedServices.sectionsContent.normalize = vi.fn(() => altNormalizedSectionsContent)
      store.commit('SET_SECTIONS_CONTENT',sectionsContent)
      await store.dispatch('addSection', {
        layoutGroupId: 'header',
        sectionDefinition: theme.sections[1]
      })
      expect(store.state.sections['GrYZW-VP'].deleted).toEqual(false)
    })
  })

  describe('#updateSectionContent', () => {
    it('marks the modified section as touched', async () => {
      store.commit('SET_SECTION', headerSections[0])
      await store.dispatch('updateSectionContent', {})
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })

  describe('#removeSection', () => {
    beforeEach(() => {
      mockedServices.sectionsContent.normalize = vi.fn(() => normalizedSectionsContent)
      mockedServices.sectionsContent.denormalize = vi.fn(() => sectionsContent)
      store.commit('SET_PAGE', page)
      store.commit('SET_SECTIONS_CONTENT', sectionsContent)
    })

    it('removes the section from the layout group', () => {
      store.dispatch('removeSection', mainSections[0].id)
      expect(store.state.sections['GrYZW-VP'].deleted).toEqual(undefined)
      expect(store.state.layoutGroups.main.sections).toStrictEqual(['xM6f-kyh'])
    })

    describe('the layout group mentions the section type as recoverable', () => {
      it('flags the section as deleted', () => {
        store.dispatch('removeSection', headerSections[0].id)
        expect(store.state.sections['GrYZW-VP'].deleted).toEqual(true)
        expect(store.state.layoutGroups.header.sections).toStrictEqual(['GrYZW-VP'])
      })
    })
  })
})
