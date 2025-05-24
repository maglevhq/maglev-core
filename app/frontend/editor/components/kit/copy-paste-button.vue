<template>
  <button @click.stop.prevent="copyToClipboard">
    <uikit-icon name="clipboard-line" size="0.75rem" v-if="!copied" class="text-gray-500 hover:text-gray-900 transition-colors duration-200" />
    <uikit-icon name="ri-check-line" size="0.75rem" class="text-green-500" v-else />
  </button>
</template>

<script>
export default {
  name: 'CopyPasteButton',
  props: {
    textToCopy: { type: String, required: true },
  },
  data() {
    return { copied: false }
  },
  methods: {
    copyToClipboard() {
      this.copied = true
      navigator.clipboard.writeText(this.textToCopy)
      const timeout = setTimeout((() => { this.copied = false }).bind(this), 2000)
      this.$once('hook:beforeDestroy', () => clearTimeout(timeout))
    },
  },
}
</script>