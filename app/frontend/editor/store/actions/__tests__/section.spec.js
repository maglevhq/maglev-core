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
  simpleContentSection,
  normalizedSimpleContentSection,
} from '@/spec/__mocks__/section'
import { site } from '@/spec/__mocks__/site'
import { theme } from '@/spec/__mocks__/theme'

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
      mockedServices.page.normalize = vi.fn(() => normalizedPage)
      mockedServices.page.denormalize = vi.fn(() => page)
      mockedServices.section.normalize = vi.fn(
        () => normalizedSimpleContentSection,
      )
      store.commit('SET_PAGE', page)
      await store.dispatch('addSection', {
        sectionDefinition: theme.sections[0],
        insertAt: 'bottom',
      })
      expect(store.state.touchedSections).toStrictEqual(['NEW-CONTENT-1'])
    })
  })

  describe('#updateSectionContent', () => {
    it('marks the modified section as touched', async () => {
      store.commit('SET_SECTION', pageSections[0])
      await store.dispatch('updateSectionContent', {})
      expect(store.state.touchedSections).toStrictEqual(['GrYZW-VP'])
    })
  })
})
