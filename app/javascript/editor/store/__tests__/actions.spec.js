// import Vuex from 'vuex'
// import { createLocalVue } from '@vue/test-utils'
// import defaultState from '../default-state'
// import buildActions from '../actions'
// import buildGetters from '../getters'
// import buildMutations from '../mutations'
// import MockedServices from '@/spec/__mocks__/services'
// import { page, normalizedPage } from '@/spec/__mocks__/page'
// import { site } from './__mocks__/site'
// import { theme } from './__mocks__/theme'

// const localVue = createLocalVue()
// localVue.use(Vuex)

// describe('Actions', () => {
//   let mockedServices = null
//   let store = null

//   beforeEach(() => {
//     mockedServices = { ...MockedServices }
//     store = new Vuex.Store({
//       state: {
//         ...defaultState,
//         theme: { ...theme },
//         site,
//       },
//       actions: buildActions(mockedServices),
//       getters: buildGetters(mockedServices),
//       mutations: buildMutations(mockedServices),
//     })
//   })

//   describe('#persistPage', () => {
//     it('calls the API with both site and page attributes', async () => {
//       mockedServices.site.find = jest.fn(async () => site)
//       mockedServices.page.normalize = jest.fn(() => normalizedPage)
//       mockedServices.page.denormalize = jest.fn(() => page)
//       mockedServices.page.findById = jest.fn(async () => page)
//       mockedServices.page.update = jest.fn(async () => ({
//         response: { status: 200 },
//       }))
//       store.commit('SET_PAGE', page)
//       await store.dispatch('persistPage')
//       expect(mockedServices.page.update).toHaveBeenCalledWith(
//         1,
//         {
//           sections: expect.any(Array),
//           lockVersion: 1,
//         },
//         {
//           sections: expect.any(Array),
//           lockVersion: 1,
//         },
//       )
//       expect(store.state.ui.saveButtonState).toEqual('success')
//     })
//     it('calls the API without the site attributes because no site scoped section has been modified', async () => {
//       mockedServices.site.find = jest.fn(async () => site)
//       mockedServices.page.normalize = jest.fn(() => normalizedPage)
//       mockedServices.page.denormalize = jest.fn(() => page)
//       mockedServices.page.findById = jest.fn(async () => page)
//       mockedServices.page.update = jest.fn(async () => ({
//         response: { status: 200 },
//       }))
//       store.commit('SET_PAGE', page)
//       store.commit('TOUCH_SECTIONS', 'GrYZW-VP')
//       await store.dispatch('persistPage')
//       expect(mockedServices.page.update).toHaveBeenCalledWith(1, {
//         sections: expect.any(Array),
//         lockVersion: 1,
//       })
//       expect(store.state.ui.saveButtonState).toEqual('success')
//     })
//   })
// })
