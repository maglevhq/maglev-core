<template>
  <button
    class="flex items-center justify-center h-6 w-6 text-sm rounded-sm"
    :class="buttonClass"
    @click="$emit('click', page)"
  >
    <slot>
      {{ page }}
    </slot>
  </button>
</template>

<script>
export default {
  name: 'PageButton',
  props: {
    page: { required: true },
    activePage: { type: Number },
  },
  computed: {
    buttonClass() {
      return {
        'bg-white': !this.enabled,
        'hover:bg-gray-100': !this.enabled,
        'text-gray-900': !this.enabled,
        'bg-editor-primary': this.enabled,
        'text-white': this.enabled,
      }
    },
    enabled() {
      return this.page === this.activePage
    },
  },
}
</script>
