<template>
  <div>
    <uikit-dropdown placement="bottom" ref="dropdown" class="h-full flex">
      <template v-slot:button>
        <button
          class="h-full w-full px-6 hover:bg-editor-primary hover:bg-opacity-5 transition-colors duration-200 flex items-center focus:outline-none focus:none"
        >
          <span>{{ $t('headerNav.previewToggler.button') }}</span>
          <uikit-icon name="arrow-down-s-line" />
        </button>
      </template>
      <template v-slot:content>
        <div class="w-48 flex flex-col">
          <a
            class="preview-link"
            target="_blank"
            :href="currentPage.previewUrl"
            >{{ $t('headerNav.previewToggler.draftLink') }}</a
          >
          <a class="preview-link" target="_blank" :href="currentPage.liveUrl">{{
            $t('headerNav.previewToggler.liveLink')
          }}</a>
        </div>
      </template>
    </uikit-dropdown>
  </div>
</template>

<script>
export default {
  name: 'PreviewToggler',
  computed: {},
}
</script>

<style scoped>
.preview-link {
  @apply px-4 py-4 hover:bg-gray-100 transition-colors duration-200 focus:outline-none cursor-pointer;
}
</style>
