<template>
  <div>
    <div
      class="
        z-10
        relative
        flex
        items-center
        focus:outline-none
        select-none
        cursor-pointer
      "
      @click.stop.prevent="toggle"
    >
      <slot name="button"></slot>
    </div>

    <!-- to close when clicked on space around it in desktop-->
    <button
      class="fixed inset-0 h-full w-full cursor-default focus:outline-none"
      v-if="open"
      @click.stop.prevent="close"
      tabindex="-1"
    ></button>

    <!--dropdown content: desktop-->
    <transition
      enter-active-class="transition-all duration-200 ease-out"
      leave-active-class="transition-all duration-750 ease-in"
      enter-class="opacity-0 scale-75"
      enter-to-class="opacity-100 scale-100"
      leave-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-75"
    >
      <div
        class="
          hidden
          md:block
          absolute
          shadow-lg
          rounded
          py-2
          px-3
          text-sm
          mt-2
          bg-white
          z-50
        "
        :class="{
          'right-0': placement === 'right',
          'left-0': placement === 'left',
          'top-auto': dropup,
          'bottom-full': dropup,
          'w-full': fullWidth,
        }"
        v-if="open"
      >
        <slot name="content"></slot>
      </div>
    </transition>

    <!--dropdown content: mobile-->
    <transition
      enter-active-class="transition-all duration-200 ease-out"
      leave-active-class="transition-all duration-750 ease-in"
      enter-class="opacity-0 scale-75"
      enter-to-class="opacity-100 scale-100"
      leave-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-75"
    >
      <div
        class="
          md:hidden
          fixed
          inset-x-0
          bottom-0
          bg-white
          w-full
          px-2
          py-2
          shadow-2xl
          leading-loose
          z-50
        "
        v-if="open"
      >
        <slot name="content"></slot>
      </div>
    </transition>
    <!-- to close when clicked on space around it in mobile-->
    <div
      class="md:hidden fixed w-full h-full inset-0 bg-gray-900 opacity-50 z-10"
      @click.stop.prevent="close"
      v-if="open"
    ></div>
  </div>
</template>

<script>
export default {
  name: 'Dropdown',
  props: {
    placement: {
      type: String,
      default: 'right',
      validator: (value) => ['right', 'left'].indexOf(value) !== -1,
    },
    dropup: { type: Boolean, default: false },
    fullWidth: { type: Boolean, default: false },
  },
  data() {
    return {
      open: false,
    }
  },
  mounted() {
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
