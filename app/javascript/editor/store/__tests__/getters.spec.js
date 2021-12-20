import Vuex from 'vuex'
import { createLocalVue } from '@vue/test-utils'
import defaultState from '@/store/default-state'
import buildGetters from '@/store/getters'
import buildMutations from '@/store/mutations'
import MockedServices from '@/spec/__mocks__/services'
import { page, normalizedPage } from '@/spec/__mocks__/page'
import { site } from '@/spec/__mocks__/site'
import { theme } from '@/spec/__mocks__/theme'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Getters', () => {
  let store = null
  let mockedServices = null

  beforeEach(() => {
    mockedServices = { ...MockedServices }
    store = new Vuex.Store({
      state: {
        ...defaultState,
        theme: { ...theme },
      },
      getters: buildGetters(mockedServices),
      mutations: buildMutations(mockedServices),
    })
    store.commit('SET_SITE', site)
  })

  describe('#content', () => {
    it('returns the content of the sections for both the site and the page', () => {
      mockedServices.page.denormalize = jest.fn(() => page)
      expect(
        store.getters.content.pageSections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP', '8hKSujtd', 'xM6f-kyh'])
      expect(
        store.getters.content.siteSections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP'])
    })
    it("doesn't return the site content sections if they haven't been touched", () => {
      store.commit('TOUCH_SECTION', 'GrYZW-VP')
      mockedServices.page.denormalize = jest.fn(() => page)
      expect(
        store.getters.content.pageSections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP', '8hKSujtd', 'xM6f-kyh'])
      expect(
        store.getters.content.siteSections.map((section) => section.id),
      ).toStrictEqual([])
    })
  })

  describe('#defaultPageAttributes', () => {
    describe("Given the page hasn't been translated", () => {
      it('returns the title + path', () => {
        const newNormalizedPage = { ...normalizedPage }
        newNormalizedPage.entities.page['1'].translated = false
        mockedServices.page.normalize = jest.fn(() => normalizedPage)
        store.commit('SET_PAGE', page)
        expect(store.getters.defaultPageAttributes).toStrictEqual({
          title: 'Home page',
          path: 'index',
        })
      })
    })
    describe('Given the page has been translated', () => {
      it('returns an empty object', () => {
        const newNormalizedPage = { ...normalizedPage }
        newNormalizedPage.entities.page['1'].translated = true
        mockedServices.page.normalize = jest.fn(() => normalizedPage)
        store.commit('SET_PAGE', page)
        expect(store.getters.defaultPageAttributes).toStrictEqual({})
      })
    })
  })

  describe('#sectionList', () => {
    it('returns a list of objects (id, type, name, viewportFixedPosition)', () => {
      mockedServices.page.denormalize = jest.fn(() => page)
      expect(store.getters.sectionList).toStrictEqual([
        {
          id: 'GrYZW-VP',
          type: 'navbar_01',
          name: 'Navbar 01',
          viewportFixedPosition: false,
        },
        {
          id: '8hKSujtd',
          type: 'content_01',
          name: 'Content #1',
          viewportFixedPosition: false,
        },
        {
          id: 'xM6f-kyh',
          type: 'list_01',
          name: 'List #1',
          viewportFixedPosition: false,
        },
      ])
    })
  })
})
