<template>
  <modal :isOpen="!!component" :title="title" :containerClass="modalClass" @on-close="handleOutsideClick">
    <component :is="component" @on-close="handleClose" v-bind="props" v-on="listeners" />
  </modal>
</template>

<script>
import { ModalBus } from '@/plugins/event-bus'

export default {
  name: 'ModalRoot',
  data() {
    return {
      component: null,
      title: '',      
      props: null,
      listeners: {},
      closeOnClick: true,
      modalClass: null,
    }
  },
  created() {
    ModalBus.$on('open', ({ component, title = '', props = null, listeners = {}, closeOnClick = true }) => {
      const { modalClass, ...componentProps } = props || {}
      this.component = component
      this.title = title
      this.props = componentProps
      this.modalClass = modalClass
      this.listeners = listeners
      this.closeOnClick = closeOnClick
    })
    ModalBus.$on('close', () => this.handleClose())
    document.addEventListener('keyup', this.handleKeyup)
  },
  beforeDestroy () {
    document.removeEventListener('keyup', this.handleKeyup)
  },
  computed: {
    containerClass() {
      return this.props?.modalClass
    }
  },
  methods: {
    handleOutsideClick (force) {
      if (!this.closeOnClick && !force) return
      this.handleClose()
    },
    handleClose () {
      this.component = null
    },
    handleKeyup (e) {
      if (e.keyCode === 27) this.handleClose()
    }
  },  
}
</script>