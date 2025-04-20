<template>
  <v-popoper
    trigger="manual"
    :autoHide="true"
    :open="open"
    :placement="placement"
    class="flex"
    v-on:auto-hide="close"
    :popoverClass="popoverClass"
  >
    <div
      class="z-10 relative flex items-center focus:outline-none select-none cursor-pointer w-full"
      @click.stop.prevent="toggle"
    >
      <slot name="button"></slot>
    </div>

    <template slot="popover">
      <slot name="content"></slot>
    </template>
  </v-popoper>
</template>

<script>
import { ModalBus } from '@/plugins/event-bus'

export default {
  name: 'UIKitDropdown',
  props: {
    placement: {
      type: String,
      default: 'bottom',
      validator: (value) =>
        ['top', 'bottom', 'right', 'left'].indexOf(value) !== -1,
    },
    popoverClass: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      open: false,
    }
  },
  mounted() {
    ModalBus.$on('open', () => this.close())
    document.addEventListener('keydown', this.onEscape)
    this.$once('hook:beforeDestroy', () => {
      document.removeEventListener('keydown', this.onEscape)
    })
  },
  methods: {
    onEscape(e) {
      if (e.key === 'Esc' || e.key === 'Escape') this.close()
    },
    toggle() {
      this.open = !this.open
      this.$emit('on-dropdown-toggle', this)
    },
    close() {
      this.open = false
    },
  },
}
</script>
