import Vuex from 'vuex'
import { describe, vi } from 'vitest'
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

  describe('#currentPagePath', () => {
    let freshNormalizedPage = null
    beforeEach(() => {
      freshNormalizedPage = structuredClone(normalizedPage)
      mockedServices.page.normalize = vi.fn(() => freshNormalizedPage)
    })
    describe('Given this is the home page', () => {
      it('returns the path of the page', () => {
        store.commit('SET_PAGE', page)
        expect(store.getters.currentPagePath).toStrictEqual('/index')
      })
    })
    describe('Given this is a random page', () => {
      it('returns the path of the page', () => {
        freshNormalizedPage.entities.page['1'].path = '/bonjour'
        freshNormalizedPage.entities.page['1'].liveUrl = '/fr/bonjour'
        store.commit('SET_PAGE', page)
        expect(store.getters.currentPagePath).toStrictEqual('/fr/bonjour')
      })
    })
    describe('Given the liveUrl contains the domain name', () => {
      it('returns the path of the page', () => {
        freshNormalizedPage.entities.page['1'].liveUrl = 'https://example.com:8080/fr'
        freshNormalizedPage.entities.page['1'].path = 'index'
        store.commit('SET_PAGE', page)
        expect(store.getters.currentPagePath).toStrictEqual('/fr/index')
      })
    })
  })

  describe('#currentPageUrl', () => {
    let freshNormalizedPage = null
    beforeEach(() => {
      freshNormalizedPage = structuredClone(normalizedPage)
      mockedServices.page.normalize = vi.fn(() => freshNormalizedPage)
    })
    describe('Given the page live URL is not prefixed with the base URL', () => {
      it('returns the url of the page', () => {
        freshNormalizedPage.entities.page['1'].liveUrl = '/hello-world'
        store.commit('SET_PAGE', page)
        expect(store.getters.currentPageUrl).toStrictEqual('http://localhost:3000/hello-world')
      })
    })
    describe('Given the page live URL is prefixed with the base URL', () => {
      it('returns the url of the page', () => {
        freshNormalizedPage.entities.page['1'].liveUrl = 'https://example.com:8080/fr'
        store.commit('SET_PAGE', page)
        expect(store.getters.currentPageUrl).toStrictEqual('https://example.com:8080/fr')
      })
    })
  })

  describe('#content', () => {
    it('returns the content of the sections for the page', () => {
      mockedServices.page.denormalize = vi.fn(() => page)
      expect(
        store.getters.content.pageSections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP', '8hKSujtd', 'xM6f-kyh'])
      expect(
        store.getters.content.siteSections.map((section) => section.id),
      ).toStrictEqual([])
    })
    it('returns the site content sections since they have been touched', () => {
      store.commit('TOUCH_SECTION', 'GrYZW-VP')
      mockedServices.page.denormalize = vi.fn(() => page)
      expect(
        store.getters.content.pageSections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP', '8hKSujtd', 'xM6f-kyh'])
      expect(
        store.getters.content.siteSections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP'])
    })
  })

  describe('#defaultPageAttributes', () => {
    describe("Given the page hasn't been translated", () => {
      it('returns the title + path', () => {
        const newNormalizedPage = { ...normalizedPage }
        newNormalizedPage.entities.page['1'].translated = false
        mockedServices.page.normalize = vi.fn(() => normalizedPage)
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
        mockedServices.page.normalize = vi.fn(() => normalizedPage)
        store.commit('SET_PAGE', page)
        expect(store.getters.defaultPageAttributes).toStrictEqual({})
      })
    })
  })

  describe('#sectionList', () => {
    it('returns a list of objects (id, type, name, viewportFixedPosition)', () => {
      mockedServices.page.denormalize = vi.fn(() => page)
      expect(store.getters.sectionList).toStrictEqual([
        {
          id: 'GrYZW-VP',
          type: 'navbar_01',
          name: 'Navbar 01',
          label: undefined,
          viewportFixedPosition: false,
        },
        {
          id: '8hKSujtd',
          type: 'content_01',
          name: 'Content #1',
          label: undefined,
          viewportFixedPosition: false,
        },
        {
          id: 'xM6f-kyh',
          type: 'list_01',
          name: 'List #1',
          label: undefined,
          viewportFixedPosition: false,
        },
      ])
    })
  })
})
