import Vuex from 'vuex'
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

  describe('#persistPage', () => {
    it('calls the API with both site and page attributes', async () => {
      mockedServices.site.find = jest.fn(async () => site)
      mockedServices.page.normalize = jest.fn(() => normalizedPage)
      mockedServices.page.denormalize = jest.fn(() => page)
      mockedServices.page.findById = jest.fn(async () => page)
      mockedServices.page.update = jest.fn(async () => ({
        response: { status: 200 },
      }))
      store.commit('SET_PAGE', page)
      await store.dispatch('persistPage')
      expect(mockedServices.page.update).toHaveBeenCalledWith(
        1,
        {
          sections: expect.any(Array),
          lockVersion: 1,
        },
        {},
      )
      expect(store.state.ui.saveButtonState).toEqual('success')
    })
    it('calls the API without the site attributes because no site scoped section has been modified', async () => {
      mockedServices.site.find = jest.fn(async () => site)
      mockedServices.page.normalize = jest.fn(() => normalizedPage)
      mockedServices.page.denormalize = jest.fn(() => page)
      mockedServices.page.findById = jest.fn(async () => page)
      mockedServices.page.update = jest.fn(async () => ({
        response: { status: 200 },
      }))
      store.commit('SET_PAGE', page)
      store.commit('TOUCH_SECTION', 'GrYZW-VP')
      await store.dispatch('persistPage')
      expect(mockedServices.page.update).toHaveBeenCalledWith(
        1,
        {
          sections: expect.any(Array),
          lockVersion: 1,
        },
        {
          sections: expect.any(Array),
          lockVersion: 1,
        },
      )
      expect(store.state.touchedSections).toEqual([])
      expect(store.state.ui.saveButtonState).toEqual('success')
    })
  })
})
