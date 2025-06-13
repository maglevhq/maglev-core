import Vuex from 'vuex'
import { describe, vi } from 'vitest'
import { createLocalVue } from '@vue/test-utils'
import defaultState from '@/store/default-state'
import buildGetters from '@/store/getters'
import buildMutations from '@/store/mutations'
import MockedServices from '@/spec/__mocks__/services'
import { page } from '@/spec/__mocks__/page'
import { sectionsContent, normalizedSectionsContent } from '@/spec/__mocks__/sections-content'
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
    // let freshNormalizedPage = null
    // beforeEach(() => {
    //   freshNormalizedPage = structuredClone(normalizedPage)
    //   mockedServices.page.normalize = vi.fn(() => freshNormalizedPage)
    // })
    describe('Given this is the home page', () => {
      it('returns the path of the page', () => {
        store.commit('SET_PAGE', page)
        expect(store.getters.currentPagePath).toStrictEqual('/index')
      })
    })
    describe('Given this is a random page', () => {
      it('returns the path of the page', () => {
        const freshPage = structuredClone(page)
        freshPage.path = '/bonjour'
        freshPage.liveUrl = '/fr/bonjour'
        store.commit('SET_PAGE', freshPage)
        expect(store.getters.currentPagePath).toStrictEqual('/fr/bonjour')
      })
    })
    describe('Given the liveUrl contains the domain name', () => {
      it('returns the path of the page', () => {
        const freshPage = structuredClone(page)
        freshPage.liveUrl = 'https://example.com:8080/fr'
        freshPage.path = 'index'
        store.commit('SET_PAGE', freshPage)
        expect(store.getters.currentPagePath).toStrictEqual('/fr/index')
      })
    })
  })

  describe('#currentPageUrl', () => {
    describe('Given the page live URL is not prefixed with the base URL', () => {
      it('returns the url of the page', () => {
        const freshPage = structuredClone(page)
        freshPage.liveUrl = '/hello-world'
        store.commit('SET_PAGE', freshPage)
        expect(store.getters.currentPageUrl).toStrictEqual('http://localhost:3000/hello-world')
      })
    })
    describe('Given the page live URL is prefixed with the base URL', () => {
      it('returns the url of the page', () => {
        const freshPage = structuredClone(page)
        freshPage.liveUrl = 'https://example.com:8080/fr'
        store.commit('SET_PAGE', freshPage)
        expect(store.getters.currentPageUrl).toStrictEqual('https://example.com:8080/fr')
      })
    })
  })

  describe('#content', () => {
    it('returns the content of the sections for the page', () => {
      mockedServices.sectionsContent.denormalize = vi.fn(() => sectionsContent)
      expect(
        store.getters.content[0].sections.map((section) => section.id),
      ).toStrictEqual(['GrYZW-VP'])
      expect(
        store.getters.content[1].sections.map((section) => section.id),
      ).toStrictEqual(['8hKSujtd', 'xM6f-kyh'])
    })
  })

  describe('#defaultPageAttributes', () => {
    describe("Given the page hasn't been translated", () => {
      it('returns the title + path', () => {
        store.commit('SET_PAGE', { ...page, translated: false })
        expect(store.getters.defaultPageAttributes).toStrictEqual({
          title: 'Home page',
          path: 'index',
        })
      })
    })
    describe('Given the page has been translated', () => {
      it('returns an empty object', () => {
        store.commit('SET_PAGE', { ...page, translated: true })
        expect(store.getters.defaultPageAttributes).toStrictEqual({})
      })
    })
  })

  describe('#sectionsContent', () => {
    it('returns the sections grouped by layout groups', () => {
      store.commit('SET_PAGE', page)
      mockedServices.sectionsContent.denormalize = vi.fn(() => sectionsContent)
      expect(store.getters.sectionsContent).toStrictEqual([
        {
          label: 'Header',
          id: 'header',
          sections: [
            {
              id: 'GrYZW-VP',
              isMirrored: false,
              mirroredPageTitle: undefined,
              name: 'Navbar 01',              
              type: 'navbar_01',
              label: undefined,
              viewportFixedPosition: false,
            }
          ],
          lockVersion: 1
        },
        {
          label: 'Main',
          id: 'main',
          sections: [
            {
              id: '8hKSujtd',
              isMirrored: false,
              mirroredPageTitle: undefined,
              name: 'Content #1',
              type: 'content_01',
              label: undefined,
              viewportFixedPosition: false,
            },
            {
              id: 'xM6f-kyh',
              isMirrored: false,
              mirroredPageTitle: undefined,
              name: 'List #1',
              type: 'list_01',
              label: undefined,
              viewportFixedPosition: false
            }
          ],
          lockVersion: 1
        },
        {
          label: 'Footer',
          id: 'footer',
          sections: [],
          lockVersion: 1
        }
      ])
    })
  })

  describe('#canAddSection', () => {
    beforeEach(() => {
      mockedServices.sectionsContent.normalize = vi.fn(() => normalizedSectionsContent)
      store.commit('SET_PAGE', page)
      store.commit('SET_SECTIONS_CONTENT', sectionsContent)
    })
    describe('the theme has many categories but without any sections', () => {
      it('returns false', () => {
        mockedServices.theme.buildCategories = vi.fn(() => ([
          {
            label: 'Navbars',
            children: []
          },
          {
            label: 'Features',
            children: []
          }
        ]))
        expect(store.getters.canAddSection('header')).toStrictEqual(false)
      })
    })
    describe('the theme has many categories with sections', () => {
      it('returns true', () => {
        mockedServices.theme.buildCategories = vi.fn(() => ([
          {
            label: 'Navbars',
            children: [{ id: 'navbar_01' }, { id: 'navbar_02' }]
          },
          {
            label: 'Features',
            children: [{ id: 'feature_01' }, { id: 'feature_02' }, { id: 'feature_03' }]
          }
        ]))
        expect(store.getters.canAddSection('header')).toStrictEqual(true)
      })
    })
  })
})
