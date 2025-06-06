import Vuex from 'vuex'
import { vi } from 'vitest'
import { createLocalVue } from '@vue/test-utils'
import defaultState from '@/store/default-state'
import buildActions from '@/store/actions'
import buildGetters from '@/store/getters'
import buildMutations from '@/store/mutations'
import MockedServices from '@/spec/__mocks__/services'
import { page, normalizedPage } from '@/spec/__mocks__/page'
import { site } from '@/spec/__mocks__/site'
import { theme } from '@/spec/__mocks__/theme'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Page Actions', () => {
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

  describe('#setCurrentPageSettings', () => {
    it('does stuff', async () => {
      mockedServices.page.normalize = vi.fn(() => normalizedPage)
      store.commit('SET_PAGE', page)
      await store.dispatch('setCurrentPageSettings', {
        title: 'UPDATED TITLE',
        lockVersion: 2,
      })
      expect(store.state.page.title).toEqual('UPDATED TITLE')
      expect(store.state.page.lockVersion).toEqual(2)
    })
  })
})
