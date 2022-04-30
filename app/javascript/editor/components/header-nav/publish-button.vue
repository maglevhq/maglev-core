<template>
  <div class="px-5 flex items-center">
    <button
      class="rounded-sm py-2 px-4 w-32 border border-gray-400 text-gray-900 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
      @click="publish"
    >
      <span>Publish site</span>
    </button>
  </div>
</template>

<script>
export default {
  name: 'PublishButton',
  computed: {
    buttonState() {
      return this.$store.state.ui.publishButtonState
    },
  },
  methods: {
    async publish() {
      console.log('TODO')
      // await this.$store.dispatch('persistPage')
    },
  },
}
</script>

<style scoped>
.bg-editor-primary {
  background-color: rgba(
    var(--editor-color-primary-non-hex),
    var(--tw-bg-opacity)
  );
}
</style>
