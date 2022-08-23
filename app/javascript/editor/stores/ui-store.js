import { defineStore } from 'pinia'
import { shallowRef } from 'vue'

export const useUIStore = defineStore('ui', {
  state: () => ({
    modals: [],
  }),
  actions: {
    openModal({ title, component, props, listeners, closeOnClick }) {
      this.modals.push({
        title,
        component: shallowRef(component),
        props,
        listeners: listeners || {},
        closeOnClick,
      })
    },
    closeModal() {
      this.modals.pop()
    },
  },
  getters: {
    currentModal: (state) => {
      return state.modals.length === 0
        ? null
        : state.modals[state.modals.length - 1]
    },
  },
})
