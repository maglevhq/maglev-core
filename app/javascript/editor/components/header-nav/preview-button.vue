<template>
  <a
    :href="currentPage.previewUrl"
    target="_blank"
    class="px-6 flex items-center hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200"
  >
    {{ $t('headerNav.previewSite') }}
  </a>
</template>

<script>
export default {
  name: 'PreviewButton',
}
</script>
