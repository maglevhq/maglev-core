<template>
  <a
    :href="currentPageUrl"
    target="_blank"
    class="px-6 flex items-center hover:bg-editor-primary/5 transition-colors duration-200"
  >
    {{ $t('headerNav.previewSite') }}
  </a>
</template>

<script>
export default {
  name: 'PreviewButton',
  computed: {
    currentPageUrl() {
      return this.currentPage.liveUrl
    },
  },
}
</script>
