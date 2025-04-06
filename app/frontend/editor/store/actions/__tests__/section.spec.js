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
import { site } from '@/spec/__mocks__/site'
import { theme } from '@/spec/__mocks__/theme'
import { normalizedSectionsContent, sectionsContent, headerSections } from '@/spec/__mocks__/sections-content'

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
    it('marks the new section as touched', async () => {
      mockedServices.section.build = vi.fn(() => simpleContentSection)
      mockedServices.sectionsContent.normalize = vi.fn(() => normalizedSectionsContent)
      mockedServices.sectionsContent.denormalize = vi.fn(() => sectionsContent)
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
  })

  describe('#updateSectionContent', () => {
    it('marks the modified section as touched', async () => {
      store.commit('SET_SECTION', headerSections[0])
      await store.dispatch('updateSectionContent', {})
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })
})
