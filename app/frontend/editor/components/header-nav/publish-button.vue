<template>
  <div class="px-5 flex items-center">
    <div
      v-if="isUninitialized"
      class="flex items-center h-10 w-44 animate-pulse"
    >
      <div class="h-full w-full bg-gray-200 rounded"></div>
    </div>

    <button
      v-else
      class="rounded-sm py-2 px-4 border transition-colors duration-200"
      :class="{
        'text-gray-400 border-gray-100 hover:bg-editor-primary/5 cursor-not-allowed':
          hasModifiedSections,
        'text-gray-900 border-gray-400 hover:bg-editor-primary/5': isReady,
        'text-gray-900 cursor-wait': isInProgress,
        'bg-green-500 border-green-500 text-white': isSuccess,
        'bg-red-600 border-red-600 text-white': isFail,
      }"
      @click="publish"
      :disabled="isInProgress || hasModifiedSections"
    >
      <span class="flex items-center justify-center space-x-2">
        <uikit-icon
          icon="circle-notch"
          name="ri-loader-4-line"
          spin
          v-if="isInProgress"
        />
        <uikit-icon name="ri-check-line" v-if="isSuccess" />
        <uikit-icon name="ri-alert-line" v-if="isFail" />
        <span>{{ label }}</span>
      </span>
    </button>
  </div>
</template>

<script>
export default {
  name: 'PublishButton',
  computed: {
    status() {
      return this.$store.state.ui.publishButtonState.status
    },
    label() {
      return (
        this.$store.state.ui.publishButtonState.label ||
        this.$t(`headerNav.publishButton.${this.status}`)
      )
    },
    isUninitialized() {
      return !this.status
    },
    hasModifiedSections() {
      return !this.isBlank(this.$store.state.touchedSections)
    },
    isReady() {
      return this.status === 'default' && !this.hasModifiedSections
    },
    isInProgress() {
      return this.status === 'inProgress'
    },
    isSuccess() {
      return this.status === 'success'
    },
    isFail() {
      return this.status === 'fail'
    },
  },
  methods: {
    async publish() {
      if (this.isReady) this.$store.dispatch('publishSite')
    },
  },
}
</script>
