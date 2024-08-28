<template>
  <uikit-modal
    :isOpen="!!currentModal"
    :title="title"
    :containerClass="containerClass"
    @on-close="handleOutsideClick"
  >
    <component
      v-for="(modal, index) in stack"
      :key="`modal-${index}`"
      :is="modal.component"
      @on-close="handleClose"
      v-bind="getModalProps(modal)"
      v-on="modal.listeners"
      v-show="index === stack.length - 1"
    />
  </uikit-modal>
</template>

<script>
import { ModalBus } from '@/plugins/event-bus'

export default {
  name: 'UIKitModalRoot',
  data() {
    return {
      stack: [], // NOTE: we stack modals!
    }
  },
  created() {
    ModalBus.$on(
      'open',
      ({
        component,
        title = '',
        props = null,
        listeners = {},
        closeOnClick = true,
      }) => {
        this.stack.push({
          component,
          title,
          props,
          listeners,
          closeOnClick,
        })
      },
    )

    ModalBus.$on('close', () => this.handleClose())
    document.addEventListener('keyup', this.handleKeyup)
  },
  beforeDestroy() {
    document.removeEventListener('keyup', this.handleKeyup)
  },
  computed: {
    currentModal() {
      return this.stack.length === 0 ? null : this.stack[this.stack.length - 1]
    },
    title() {
      return this.currentModal?.title
    },
    containerClass() {
      return this.currentModal?.props?.modalClass
    }
  },
  methods: {
    handleOutsideClick(force) {
      if (!this.closeOnClick && !force) return
      this.handleClose()
    },
    handleKeyup(e) {
      if (e.keyCode === 27) this.handleClose()
    },
    handleClose() {
      if (!this.currentModal) return
      this.stack.pop()
    },
    getModalProps(modal) {
      const { modalClass, ...rest } = (modal.props ?? {})
      return rest
    }
  },
}
</script>
