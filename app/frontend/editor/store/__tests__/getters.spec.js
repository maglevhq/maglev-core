import Vuex from 'vuex'
import { vi } from 'vitest'
import { createLocalVue } from '@vue/test-utils'
import defaultState from '@/store/default-state'
import buildGetters from '@/store/getters'
import buildMutations from '@/store/mutations'
import MockedServices from '@/spec/__mocks__/services'
import { page, normalizedPage } from '@/spec/__mocks__/page'
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
              viewportFixedPosition: false,
            },
            {
              id: 'xM6f-kyh',
              isMirrored: false,
              mirroredPageTitle: undefined,
              name: 'List #1',
              type: 'list_01',
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
})
