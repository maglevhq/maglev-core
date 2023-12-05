<template>
  <div>
    <div
      class="flex items-center cursor-pointer select-none"
      :class="headerClass"
      @click="toggle"
    >
      <slot name="header">HINT</slot>
      <button class="ml-auto">
        <uikit-icon
          name="arrow-up-s-line"
          size="1.5rem"
          class="ml-auto"
          v-if="show"
        />
        <uikit-icon
          name="arrow-down-s-line"
          size="1.5rem"
          class="ml-auto"
          v-else
        />
      </button>
    </div>
    <transition
      name="accordion"
      v-on:before-enter="beforeEnter"
      v-on:enter="enter"
      v-on:before-leave="beforeLeave"
      v-on:leave="leave"
    >
      <div
        class="overflow-hidden transition-all duration-150 select-none"
        v-show="show"
      >
        <slot></slot>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'UIKitAccordion',
  props: {
    headerClass: { type: String, default: '' },
  },
  data() {
    return { show: false }
  },
  methods: {
    toggle() {
      this.show = !this.show
    },
    beforeEnter(el) {
      el.style.height = '0'
    },
    enter(el) {
      el.style.height = el.scrollHeight + 'px'
    },
    beforeLeave(el) {
      el.style.height = el.scrollHeight + 'px'
    },
    leave(el) {
      el.style.height = '0'
    },
  },
}
</script>
